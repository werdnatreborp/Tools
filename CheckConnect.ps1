Get-Service -ServiceName "MBEndpointAgent","MBAMService"

$r = [System.Net.WebRequest]::Create("https://cdn.mwbsys.com/packages")
$resp = $r.GetResponse()
$reqstream = $resp.GetResponseStream()
$sr = new-object System.IO.StreamReader $reqstream
$result = $sr.ReadToEnd()
write-host $result

<#

$sirius = Invoke-WebRequest "https://sirius.mwbsys.com"
Write-Host Sirius $($sirius.StatusDescription)
<# try {	
	$ark    = Invoke-WebRequest "https://ark.mwbsys.com/ncep-win.installer.common/release"
	Write-Host ARK ($ark.StatusDescription)	
}
catch
{
	Write-Host $($Error.ErrorDetails.Message)
}
#>


Invoke-WebRequest "https://cdn.mwbsys.com/packages"
Write-Host $Error.Exception.Message
Write-Host $Error.CategoryInfo
Write-Host $Error.FullyQualifiedErrorId
Write-Host $Error.ErrorDetails.Message	
Write-Host $Error[1].ToString()



try {
	$cdn = Invoke-WebRequest "https://cdn.mwbsys.com/packages" -ErrorAction 
Write-Host $cdn
}
catch
{
	Write-Host $cdn
	Write-Host $($Error.ErrorDetails.Message)
}

#>
