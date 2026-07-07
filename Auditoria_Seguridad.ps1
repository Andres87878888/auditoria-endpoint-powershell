clear
# Definir ruta del archivo de reporte
$ReportePath = ".\Reporte_Seguridad_Local.txt"

# Iniciar la captura de pantalla hacia el archivo de texto de forma simultanea
Start-Transcript -Path $ReportePath -Force | Out-Null

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "    INICIANDO ANALISIS DE SEGURIDAD LOCAL (ENDPOINT)     " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Fecha del reporte: $(Get-Date)" -ForegroundColor Gray
Write-Host ""

# 1. VERIFICACION DE ANTIVIRUS
Write-Host "[*] REVISANDO ESTADO DEL ANTIVIRUS..." -ForegroundColor Yellow
$Defender = Get-MpComputerStatus
if ($Defender.RealTimeProtectionEnabled -eq $true) {
    Write-Host "[+] PROTECCION EN TIEMPO REAL: ACTIVA" -ForegroundColor Green
} else {
    Write-Host "[-] ALERTA: PROTECCION EN TIEMPO REAL DESACTIVADA!" -ForegroundColor Red
}
Write-Host "    Ultima actualizacion de firmas: $($Defender.AntivirusSignatureLastUpdated)" -ForegroundColor Gray
Write-Host ""

# 2. VERIFICACION DE FIREWALL
Write-Host "[*] REVISANDO ESTADO DEL FIREWALL DE WINDOWS..." -ForegroundColor Yellow
$FirewallDomain = Get-NetFirewallProfile -Profile Domain
$FirewallPrivate = Get-NetFirewallProfile -Profile Private
$FirewallPublic = Get-NetFirewallProfile -Profile Public

if ($FirewallPublic.Enabled -eq "True" -and $FirewallPrivate.Enabled -eq "True") {
    Write-Host "[+] FIREWALL DE WINDOWS: ACTIVADO Y PROTEGIENDO" -ForegroundColor Green
} else {
    Write-Host "[-] ALERTA: EL FIREWALL PODRIA ESTAR DESACTIVADO EN ALGUN PERFIL!" -ForegroundColor Red
}
Write-Host ""

# 3. AUDITORIA DE USUARIOS ADMINISTRADORES LOCALES
Write-Host "[*] AUDITANDO MIEMBROS DEL GRUPO ADMINISTRADORES..." -ForegroundColor Yellow
Write-Host "    (Verifica que no existan cuentas desconocidas con privilegios altos)" -ForegroundColor Gray
Get-LocalGroupMember -Group "Administradores" | Select-Object Name, PrincipalSource | Format-Table
Write-Host ""

# 4. CONEXIONES Y PUERTOS ABIERTOS
Write-Host "[*] ESCANEANDO PUERTOS INTERNOS Y CONEXIONES ACTIVAS..." -ForegroundColor Yellow
Write-Host "    (Mostrando las primeras 5 conexiones locales para auditoria)" -ForegroundColor Gray
Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State -First 5 | Format-Table
Write-Host ""

# 5. REVISION DE ACTUALIZACIONES CRITICAS PENDIENTES
Write-Host "[*] BUSCANDO PARCHES DE SEGURIDAD PENDIENTES..." -ForegroundColor Yellow
Write-Host "    (Esto puede tardar unos segundos)..." -ForegroundColor Gray
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
$SearchResult = $UpdateSearcher.Search("IsInstalled=0 and Type='Software' and IsHidden=0")

if ($SearchResult.Updates.Count -eq 0) {
    Write-Host "[+] SISTEMA AL DIA: No hay actualizaciones criticas pendientes." -ForegroundColor Green
} else {
    Write-Host "[-] ATENCION: El sistema tiene $($SearchResult.Updates.Count) actualizaciones pendientes por instalar." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    [!] ACCIONES RECOMENDADAS PARA MITIGACION:" -ForegroundColor Cyan
    Write-Host "    --> Para actualizar tus PROGRAMAS/APLICACIONES de forma masiva, ejecuta:" -ForegroundColor Gray
    Write-Host "        winget upgrade --all" -ForegroundColor Green
    Write-Host ""
    Write-Host "    --> Para forzar la instalacion de la ACTUALIZACION DE WINDOWS desde aqui, ejecuta:" -ForegroundColor Gray
    Write-Host "        Install-Module PSWindowsUpdate -Force; Get-WindowsUpdate -Install -AcceptAll" -ForegroundColor Green
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "            ANALISIS COMPLETADO EXITOSAMENTE              " -ForegroundColor Cyan
Write-Host "    [i] Se ha guardado una copia de este reporte en:" -ForegroundColor Gray
Write-Host "        $ReportePath" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

# Detener la captura del reporte
Stop-Transcript | Out-Null

Read-Host "Presiona Enter para salir"