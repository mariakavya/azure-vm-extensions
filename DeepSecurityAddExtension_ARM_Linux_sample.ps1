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
    [Parameter(Mandatory=$true)][string]$vmName,

    # Publisher of Azure Extension
    [Parameter(Mandatory=$false)][string]$extPublisher="TrendMicro.DeepSecurity",
    # Name of Azure Extension
    [Parameter(Mandatory=$false)][string]$extName="TrendMicroDSALinux",
    # Version of Azure Extension
    [Parameter(Mandatory=$false)][ValidateSet("9.6","10.0")][string]$extVersion
 )
$protectedFileContent = Get-Content -Raw -LiteralPath $privateFileName -Encoding UTF8 -ErrorAction Stop
$publicFileContent = Get-Content -Raw -LiteralPath $publicFileName -Encoding UTF8 -ErrorAction Stop

function Get-DeepSecurityExtensionLatestVersion {
 param (
        [Parameter(Mandatory=$true,Position=0)][string]$location,
        [Parameter(Mandatory=$true,Position=1)][string]$extPublisher,
        [Parameter(Mandatory=$true,Position=2)][string]$extName
    )

    $ver = Get-AzureRmVMExtensionImage -Location $location -PublisherName $extPublisher -Type $extName -ErrorAction Stop | Sort-Object -Property Version | Select-Object -Property Version -First 1
    return $ver
}

try{
    if($extVersion) {
        $ver = $extVersion
    } else {
        $ver = Get-DeepSecurityExtensionLatestVersion $location $extPublisher $extName
    }

    if( $ver -match "(\d+\.\d+)\.*") {  # get first two version-number (eg : get A.B from A.B.C.D)
        $ver = $Matches[1]
    }

    Set-AzureRMVMExtension -ResourceGroupName $resourceGroupName -Location $location -VMName $vmName -Name $extName -Publisher $extPublisher -ExtensionType $extName -TypeHandlerVersion $ver -SettingString $publicFileContent -ProtectedSettingString $protectedFileContent -ErrorAction Stop
    
}catch {
   Write-Error -Exception $_.Exception
   exit 1
}

exit 0


