[CmdletBinding()]
Param(
   [Parameter()]
   [Alias("SubscriptionID")]
   [string]$global:SubscriptionID,

   [Parameter()]
   [Alias("mode")]
   [string]$global:mode,

   [Parameter()]
   [Alias("sqllogin")]
   [string]$global:sqlServerLogin = 'mylogin',

   [Parameter()]
   [Alias("sqlpassword")]
   [string]$global:sqlServerPassword = 'pass@word1'   
)

function ValidateParameters{
    $modeList = 'deploy', 'delete'
    if($modeList -notcontains $global:mode){
        Write-Host ''
        Write-Host '请输入操作模式: 模式必须为下列之一: ' $modeList
        $global:mode = Read-Host 'Enter mode'
        while($modeList -notcontains $global:mode){
            Write-Host '非法模式。请从上述列表中选择其中一个操作模式。'
            $global:mode = Read-Host '请输入模式：'                     
        }
    }

    $global:useCaseName = 'FraudAnalysis'

    Write-Host
    Write-Host '------------------------------------------' 
    Write-Host '模式: ' $global:mode > setup-log.txt
    Write-Host '用例: ' $global:useCaseName   
    Write-Host '------------------------------------------' 
}

function SetGlobalParams {
    #this function must be called after ValidateParams
    
    #The location should be either 'China North' or 'China East' for Mooncake deployments
    [string]$global:location = 'China North'
    [string]$global:locationMultiWord = 'China North'


    $output = ($global:useCaseName + $env:COMPUTERNAME).Replace('-','').Replace('_','').ToLower()
    
    if($output.Length -gt 24) { $output = $output.Remove(23) }

		
    $global:useCaseName = $global:useCaseName.ToLower()

    $global:defaultResourceName = $output 
    $global:storageAccountName = $output
    $global:storageAccountKey = ""
    $global:blobContainerName =$output
	$global:storageconnectonstring = ""
	
    $global:resourceGroupName = $output
    $global:affinityGroupName = $output

    $global:sqlserverName = $output+'-dw'
    $global:sqlDBName = $output
    
    
    $global:configPath = ('.\temp\setup\' + $global:useCaseName + '.txt')

    $global:dict = @{}    
    $global:progressMessages = New-Object System.Collections.ArrayList($null)

}

function InitSubscription{
    #login
    $account = Login-AzureRmAccount -EnvironmentName AzureChinaCloud
	Write-Host You are signed-in with $account.Context.Account
	
	
    if($global:subscriptionID -eq $null -or $global:subscriptionID -eq ''){
         $subList = Get-AzureRMSubscription

        if($subList.Length -lt 1){
            throw '您的账户没有任何订阅，请先增加订阅再完成本实验，谢谢！'
        } 

        $subCount = 0
        foreach($sub in $subList){
            $subCount++
            $sub | Add-Member -type NoteProperty -name RowNumber -value $subCount
        }

        Write-Host ''
        Write-Host '您的 Azure 订阅: '
        $subList | Format-Table RowNumber,SubscriptionId,SubscriptionName -AutoSize
        $rowNum = Read-Host '请选择要安装的Azure订阅号 (1 -'$subCount') '

        while( ([int]$rowNum -lt 1) -or ([int]$rowNum -gt [int]$subCount)){
            Write-Host '订阅不存在，请从列表中选择一个订阅号以便进行安装。'
            $rowNum = Read-Host '请输入订阅行号：'                     
        }
        $global:subscriptionID = $subList[$rowNum-1].SubscriptionId;
        $global:subscriptionName = $subList[$rowNum-1].SubscriptionName;
        $global:subscriptionName = "Beta Subscription";
    }

    #switch to appropriate subscription
    try{
        
        Select-AzureRMSubscription -SubscriptionId $global:subscriptionID
        
        # Select-AzureSubscription $subList[[int]$rowNum-1].SubscriptionName
        $global:dict.Add('<subId>', $global:subscriptionID)
        $global:dict.Add('<subName>', $subList[[int]$rowNum-1].SubscriptionName)
    } catch {
        throw '所提供的订阅ID不存在: ' + $global:subscriptionID 
    }
}

function CreateResourceGroup{
   
    #create resource group
    $rg = $null
    try{
        Write-Host '创建Azure资源组 [' $global:resourceGroupName ']......' -NoNewline 
        $rg = New-AzureRmResourceGroup -Name ($global:resourceGroupName) -location $global:location -ErrorAction Stop -Force | out-null
        #will update if already exists
    } catch {
        Write-Host '创建操作错误.' 
        throw
    }
    Write-Host '已创建.' 
    return $rg
}

function DeleteResourceGroup{
   
    try{
        Write-Host '删除Azure资源组 [' $global:resourceGroupName ']......' -NoNewline
        Remove-AzureRmResourceGroup -Name $global:resourceGroupName -Force -ErrorAction Stop
    }catch [ArgumentException]{
        # resource group does not exist
    } catch {
        Write-Host '删除操作错误.'
    }
    Write-Host '已删除.'
}

function CreateSQLServerAndADW{
   process{
        Write-Host '创建 SQL Server ...... ' -NoNewline
        #create sql server & DB
    
        $sqlsvr = $null
        $createdNew = $FALSE
        
        try{ 
            $secpasswd = ConvertTo-SecureString $global:sqlServerPassword -AsPlainText -Force
            $servercredential = New-Object System.Management.Automation.PSCredential ($global:sqlServerLogin, $secpasswd)
            
            $sqlsvr = New-AzureRmSqlServer -ResourceGroupName $global:resourceGroupName -Location $global:locationMultiWord -ServerName $global:sqlserverName -SqlAdministratorCredentials $servercredential -ServerVersion "12.0"
            Write-Host '[SQL Server: ' $global:sqlserverName ']....已创建.' 
            $sqlsvrname = $sqlsvr.ServerName
            $createdNew = $TRUE;
              
        } catch{        
            Write-Host '创建操作失败.'
            throw
        }

        if($createdNew){
         
         
            Start-Sleep -s 30
            Write-Host "添加防火墙规则 $global:sqlserverName"
            $rule1 = New-AzureSqlDatabaseServerFirewallRule -ServerName $global:sqlserverName -AllowAllAzureServices -ErrorAction Continue 
            $rule2 = New-AzureSqlDatabaseServerFirewallRule -ServerName $global:sqlserverName -RuleName “AllIPAllowRule” -StartIPAddress 0.0.0.0 -EndIPAddress 255.255.255.255 -ErrorAction Continue 
            
            Start-Sleep -s 120
            $global:progressMessages.Add("创建数据库 - $global:sqlDBName")     
            try{
                Write-Host '创建 SQL 数据仓库 [' $global:sqlDBName ']......' -NoNewline 
                
                #create a connection context
                $sqldb =New-AzureRmSqlDatabase -RequestedServiceObjectiveName "DW200" -DatabaseName "fraudanalysisdw" -ServerName $global:sqlserverName -ResourceGroupName $global:resourceGroupName -Edition "DataWarehouse" >> setup-log.txt
                
                Write-Host '已创建.'
                $dbCreated = $TRUE;

                Write-Host 'SQL DW 连接串信息'
                Write-Host 'SQL Server 名称 :' $global:sqlserverName
                Write-Host 'SQL Server 密码 :' $global:sqlServerPassword
                Write-Host 'SQL Database 名称 : fraudanalysisdw'

                
            } catch {
                Write-Host '创建操作失败.'
                throw
            }
        }
        return $sqldb
    } 
}

function DeleteSQLServerAndADW{ 

}


ValidateParameters
SetGlobalParams
InitSubscription

$Global:VerbosePreference = "SilentlyContinue"
$setupDate = [DateTimeoffset]::Now
echo "Setup Logs" > setup-log.txt
echo $setupDate.ToString()  >> setup-log.txt
echo "-------------------------------------------------------" >> setup-log.txt

try {
    switch($global:useCaseName){
        'fraudanalysis'{
            switch($global:mode){
                'deploy'{
                    CreateResourceGroup
                    CreateSQLServerAndADW
                }
                'delete'{
                    DeleteResourceGroup
                }
            }    
        }
      }
}
catch  
{
  
        Write-Host '安装失败. 请联络微软技术团队获得帮助. '
        throw
      
}