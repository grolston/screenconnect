
$PS1FileContents = @'
## The following ensures the screenconnect service is running
$ScreenConnectServices = Get-Service ScreenConnect*

foreach($ScreenConnectService in $ScreenConnectServices) {
  if($ScreenConnectService.Status -NE "Running") {
    try {
      Start-Service $ScreenConnectService -ErrorAction Stop
    }
    catch {
      sleep -Seconds 20
      Start-Service $ScreenConnectService
    }
  }
}
'@
$PS1File = C:\ScreenConnectStartup.ps1
$PS1FileContents | Out-File $PS1File -NoClobber:$false -Force


# set the account which will be run under
$RunAs = 'NT AUTHORITY\SYSTEM'
# create the scheduled task
schtasks /CREATE  /TN "ScreenConnect Service Start" /TR "powershell.exe -noprofile -executionpolicy Unrestricted -File $PS1File"  /RL HIGHEST /SC onstart