 param (
    # Private config file path
    [Parameter(Mandatory=$true)][string]$privateFileName,
    # Public config file path
    [Parameter(Mandatory=$true)][string]$publicFileName,
    # Resource group location
    [Parameter(Mandatory=$true)][string]$location,
    # Resource group name where VM is located
    [Parameter(Mandatory=$true)][string]$resourceGroupName,
    # VM name
    [Parameter(Mandatory=$true)][string]$vmName
 )

$dsaExtPublisher = "TrendMicro.DeepSecurity"
$dsaExtName = "TrendMicroDSALinux"

$protectedFileContent = Get-Content -Raw -LiteralPath $privateFileName -Encoding UTF8 -ErrorAction Stop
$publicFileContent = Get-Content -Raw -LiteralPath $publicFileName -Encoding UTF8 -ErrorAction Stop

try{

    $ver = Get-AzureRmVMExtensionImage -Location $location -PublisherName $dsaExtPublisher -Type $dsaExtName -ErrorAction Stop | Sort-Object -Property Version | Select-Object -Property Version -First 1
    
    if( $ver -match "(\d+\.\d+)\.*") {  # get first two version-number (eg : get A.B from A.B.C.D)
        $ver = $Matches[1]
    }
    Set-AzureRMVMExtension -ResourceGroupName $resourceGroupName -Location $location -VMName $vmName -Name $dsaExtName -Publisher $dsaExtPublisher -ExtensionType $dsaExtName -TypeHandlerVersion $ver -SettingString $publicFileContent -ProtectedSettingString $protectedFileContent -ErrorAction Stop
    
}catch {
   Write-Error -Exception $_.Exception
   exit 1
}

exit 0


