# Novo banco de dados no Azure
# Ivo Dias

# Configuracoes
$subscriptionId = '<SubscriptionID>'
$resourceGroupName = "meuGrupoRecursos-$(Get-Random)"
$location = "West US"
$adminLogin = "azureuser"
$password = "PWD27!"+(New-Guid).Guid
$serverName = "mysqlserver-$(Get-Random)"
$databaseName = "mySampleDatabase"

# Range de IP permitido
$startIp = "0.0.0.0"
$endIp = "0.0.0.0"

# Mostra os valores gerados
Write-host "Grupo de Recursos:" $resourceGroupName
Write-host "Senha:" $password  
Write-host "Servidor:" $serverName

# Conecta ao Azure
Connect-AzAccount

# Se conecta ao ambiente
Set-AzContext -SubscriptionId $subscriptionId

# Cria um novo grupo de recursos
Write-host "Criando um grupo de recursos..."
$resourceGroup = New-AzResourceGroup -Name $resourceGroupName -Location $location -Tag @{Owner="SQLDB-Samples"}
$resourceGroup

# Cria um servidor primario
Write-host "Criando servidor logico primario..."
$server = New-AzSqlServer -ResourceGroupName $resourceGroupName `
   -ServerName $serverName `
   -Location $location `
   -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential `
   -ArgumentList $adminLogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))
$server

# Configura o Firewall
Write-host "Configurando Firewall..."
$serverFirewallRule = New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
   -ServerName $serverName `
   -FirewallRuleName "AllowedIPs" -StartIpAddress $startIp -EndIpAddress $endIp
$serverFirewallRule

# Cria o banco
Write-host "Criando um banco de dados: gen5 2 vCore..."
$database = New-AzSqlDatabase  -ResourceGroupName $resourceGroupName `
   -ServerName $serverName `
   -DatabaseName $databaseName `
   -Edition GeneralPurpose `
   -VCore 2 `
   -ComputeGeneration Gen5 `
   -MinimumCapacity 2 `
   -SampleName "AdventureWorksLT"
$database