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