 param (
    # Private config file path
    [Parameter(Mandatory=$true)][string]$privateFileName,
    # Public config file path
    [Parameter(Mandatory=$true)][string]$publicFileName,
    # Cloud service name where VM is located
    [Parameter(Mandatory=$true)][string]$cloudServiceName,
    # VM name
    [Parameter(Mandatory=$true)][string]$vmName
 )

$dsaExtPublisher = "TrendMicro.DeepSecurity"
$dsaExtName = "TrendMicroDSA"

$protectedFileContent = Get-Content -Raw -LiteralPath $privateFileName -Encoding UTF8 -ErrorAction Stop
$publicFileContent = Get-Content -Raw -LiteralPath $publicFileName -Encoding UTF8 -ErrorAction Stop

try {
    $ver = (Get-AzureVMAvailableExtension -ExtensionName $dsaExtName –Publisher $dsaExtPublisher -ErrorAction Stop).Version
    $vm = Get-AzureVM -ServiceName $cloudServiceName -Name $vmName -ErrorAction Stop
    Set-AzureVMExtension -VM $vm -Version $ver -ExtensionName $dsaExtName -Publisher $dsaExtPublisher -PrivateConfiguration $protectedFileContent -PublicConfiguration $publicFileContent -ErrorAction Stop| Update-AzureVM
}catch {
   Write-Error -Exception $_.Exception
   exit 1
}

exit 0