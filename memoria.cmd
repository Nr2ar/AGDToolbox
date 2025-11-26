@echo off
powershell -NoLogo -NoProfile -Command "$ev=Get-WinEvent -FilterHashtable @{LogName='System';ProviderName='Microsoft-Windows-MemoryDiagnostics-Results'} 2>$null; foreach ($e in $ev){$msg=$e.Message; if($msg -match 'error' -or $msg -match 'failed' -or $msg -match 'problema'){Write-Host 'ERROR' -ForegroundColor Red; Write-Host $msg -ForegroundColor Red;} else {Write-Host 'OK' -ForegroundColor Green; Write-Host $msg -ForegroundColor Green;}}"


@echo off
powershell -NoLogo -NoProfile -Command "$ev=Get-WinEvent -FilterHashtable @{LogName='System';ProviderName='Microsoft-Windows-MemoryDiagnostics-Results'} 2>$null; foreach ($e in $ev){$msg=$e.Message; Write-Output $msg;}"
