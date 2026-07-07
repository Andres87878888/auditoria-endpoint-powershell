clear
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "    INICIANDO ANALISIS DE SEGURIDAD LOCAL (ENDPOINT)     " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Fecha del reporte: $(Get-Date)" -ForegroundColor Gray
Write-Host ""

# 1. VERIFICACIÓN DE ANTIVIRUS
Write-Host "[*] REVISANDO ESTADO DEL ANTIVIRUS..." -ForegroundColor Yellow
$Defender = Get-MpComputerStatus
if ($Defender.RealTimeProtectionEnabled -eq $true) {
    Write-Host "[+] PROTECCIÓN EN TIEMPO REAL: ACTIVA" -ForegroundColor Green
} else {
    Write-Host "[-] ALERTA: ¡PROTECCIÓN EN TIEMPO REAL DESACTIVADA!" -ForegroundColor Red
}
Write-Host "    Última actualización de firmas: $($Defender.AntivirusSignatureLastUpdated)" -ForegroundColor Gray
Write-Host ""

# 2. VERIFICACIÓN DE FIREWALL
Write-Host "[*] REVISANDO ESTADO DEL FIREWALL DE WINDOWS..." -ForegroundColor Yellow
$FirewallDomain = Get-NetFirewallProfile -Profile Domain
$FirewallPrivate = Get-NetFirewallProfile -Profile Private
$FirewallPublic = Get-NetFirewallProfile -Profile Public

if ($FirewallPublic.Enabled -eq "True" -and $FirewallPrivate.Enabled -eq "True") {
    Write-Host "[+] FIREWALL DE WINDOWS: ACTIVADO Y PROTEGIENDO" -ForegroundColor Green
} else {
    Write-Host "[-] ALERTA: ¡EL FIREWALL PODRÍA ESTAR DESACTIVADO EN ALGÚN PERFIL!" -ForegroundColor Red
}
Write-Host ""

# 3. CONEXIONES Y PUERTOS ABIERTOS (Muestra conexiones activas)
Write-Host "[*] ESCANEANDO PUERTOS INTERNOS Y CONEXIONES ACTIVAS..." -ForegroundColor Yellow
Write-Host "    (Mostrando las primeras 5 conexiones locales para auditoría)" -ForegroundColor Gray
Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State -First 5 | Format-Table
Write-Host ""

# 4. REVISIÓN DE ACTUALIZACIONES CRÍTICAS PENDIENTES
Write-Host "[*] BUSCANDO PARCHES DE SEGURIDAD PENDIENTES..." -ForegroundColor Yellow
Write-Host "    (Esto puede tardar unos segundos)..." -ForegroundColor Gray
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
$SearchResult = $UpdateSearcher.Search("IsInstalled=0 and Type='Software' and IsHidden=0")

if ($SearchResult.Updates.Count -eq 0) {
    Write-Host "[+] SISTEMA AL DÍA: No hay actualizaciones críticas pendientes." -ForegroundColor Green
} else {
    Write-Host "[-] ATENCIÓN: El sistema tiene $($SearchResult.Updates.Count) actualizaciones pendientes por instalar." -ForegroundColor Orange
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "            ANÁLISIS COMPLETADO EXITOSAMENTE              " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Read-Host "Presiona Enter para salir"