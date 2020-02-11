function Test-IsAdmin {
  ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}#close Test-IsAdmin

$PS1FileContents = @'
## The following ensures the screenconnect service is running
$count = 1
while($count -lt 2)
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
  $count++
}
'@

if(Test-IsAdmin){
  echo "running installer as admin"
  $PS1File = C:\ScreenConnectStartup.ps1
  $PS1FileContents | Out-File $PS1File -NoClobber:$false -Force
  echo "new $PS1File created."
  # set the account which will be run under
  $RunAs = 'NT AUTHORITY\SYSTEM'
  # create the scheduled task
  schtasks /CREATE  /TN "ScreenConnect Service Start" /TR "powershell.exe -noprofile -executionpolicy Unrestricted -File $PS1File"  /RL HIGHEST /SC onstart /s $env:COMPUTERNAME  /RU $RunAs
  echo "service scheduled to run at start executing file $PS1File"
}
else{
  echo "installation session not running under admin permissions."
}