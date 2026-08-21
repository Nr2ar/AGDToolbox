@echo off
set TargetID=2049

powershell -NoProfile -ExecutionPolicy Bypass "$cs = Get-CimInstance Win32_ComputerSystem; if ($cs.PartOfDomain) { $cred = Get-Credential -Message 'Ingrese una cuenta con permisos para renombrar el equipo en el dominio'; Rename-Computer -NewName 'ID%TargetID%' -DomainCredential $cred -Force; } else {  }"