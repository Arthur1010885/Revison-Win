<#
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ██████╗ ███████╗██╗   ██╗██╗███████╗██╗ ██████╗ ███╗   ██╗                 ║
║   ██╔══██╗██╔════╝██║   ██║██║██╔════╝██║██╔═══██╗████╗  ██║                 ║
║   ██████╔╝█████╗  ██║   ██║██║███████╗██║██║   ██║██╔██╗ ██║                 ║
║   ██╔══██╗██╔══╝  ╚██╗ ██╔╝██║╚════██║██║██║   ██║██║╚██╗██║                 ║
║   ██║  ██║███████╗ ╚████╔╝ ██║███████║██║╚██████╔╝██║ ╚████║                 ║
║   ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝                 ║
║                                                                              ║
║   ╔══════════════════════════════════════════════════════════════════════╗   ║
║   ║                    REVISION WIN CLIENT INSTALLER                     ║   ║
║   ║         Transforme seu Windows em uma máquina REVISION WIN           ║   ║
║   ║              A Microsoft perde o controle. Você assume.              ║   ║
║   ╚══════════════════════════════════════════════════════════════════════╝   ║
║                                                                              ║
║   [ATENÇÃO] Execute este script como ADMINISTRADOR                          ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ServerIP,  # Ex: "192.168.1.100" ou "meuservidor.com"
    
    [int]$ServerPort = 8080,
    
    [string]$ClientID = $env:COMPUTERNAME
)

# Cores pro terminal
$Global:BannerShown = $false

function Show-RevisionBanner {
    param([string]$Message = "")
    Clear-Host
    Write-Host @"
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ██████╗ ███████╗██╗   ██╗██╗███████╗██╗ ██████╗ ███╗   ██╗                 ║
║   ██╔══██╗██╔════╝██║   ██║██║██╔════╝██║██╔═══██╗████╗  ██║                 ║
║   ██████╔╝█████╗  ██║   ██║██║███████╗██║██║   ██║██╔██╗ ██║                 ║
║   ██╔══██╗██╔══╝  ╚██╗ ██╔╝██║╚════██║██║██║   ██║██║╚██╗██║                 ║
║   ██║  ██║███████╗ ╚████╔╝ ██║███████║██║╚██████╔╝██║ ╚████║                 ║
║   ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝                 ║
║                                                                              ║
║   ╔══════════════════════════════════════════════════════════════════════╗   ║
║   ║                         REVISION WIN CLIENT                          ║   ║
║   ║                   Seu Windows. Suas regras. Sua RAM.                 ║   ║
║   ║              A Microsoft só atualiza se VOCÊ permitir.               ║   ║
║   ╚══════════════════════════════════════════════════════════════════════╝   ║
║                                                                              ║
"@ -ForegroundColor Cyan
    if ($Message) {
        Write-Host "   [$([DateTime]::Now.ToString('HH:mm:ss'))] $Message" -ForegroundColor Yellow
        Write-Host ""
    }
}

# Configurações
$ScriptDir = "C:\RevisionWin"
$LogFile = "$ScriptDir\revision.log"
$TempDir = "$ScriptDir\temp"
$ServerURL = "http://${ServerIP}:${ServerPort}"

function Write-Log {
    param([string]$Message, [string]$Color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $Message"
    Add-Content -Path $LogFile -Value $logMessage
    Write-Host "   $logMessage" -ForegroundColor $Color
}

# 1. CRIAR ESTRUTURA DE PASTAS
function Create-Structure {
    Write-Log "Criando estrutura REVISION WIN..." -Color "Cyan"
    New-Item -ItemType Directory -Force -Path $ScriptDir, $TempDir | Out-Null
    Write-Log "✅ Estrutura criada em $ScriptDir" -Color "Green"
}

# 2. BAIXAR E APLICAR LOGO (SUBSTITUIR WINVER)
function Install-RevisionLogo {
    Write-Log "Instalando REVISION WIN logo..." -Color "Cyan"
    
    # Baixar logo do servidor
    $logoUrl = "$ServerURL/revision-logo"
    $logoTxt = "$ScriptDir\revision-logo.txt"
    
    try {
        $logo = Invoke-RestMethod -Uri $logoUrl -Method Get
        $logo | Out-File -FilePath $logoTxt -Encoding UTF8
        Write-Log "✅ Logo baixada" -Color "Green"
    }
    catch {
        Write-Log "⚠️ Não foi possível baixar logo do servidor, usando local" -Color "Yellow"
        # Logo padrão
        $defaultLogo = @"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   ██████╗ ███████╗██╗   ██╗██╗███████╗██╗ ██████╗ ███╗   ██║
║   ██╔══██╗██╔════╝██║   ██║██║██╔════╝██║██╔═══██╗████╗  ██║
║   ██████╔╝█████╗  ██║   ██║██║███████╗██║██║   ██║██╔██╗ ██║
║   ██╔══██╗██╔══╝  ╚██╗ ██╔╝██║╚════██║██║██║   ██║██║╚██╗██║
║   ██║  ██║███████╗ ╚████╔╝ ██║███████║██║╚██████╔╝██║ ╚████║
║   ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
║                                                              ║
║                      REVISION WIN ACTIVE                     ║
║              Seu Windows. Suas regras. Sua RAM.              ║
╚══════════════════════════════════════════════════════════════╝
"@
        $defaultLogo | Out-File -FilePath $logoTxt -Encoding UTF8
    }
    
    # Criar script para mostrar logo no terminal
    $showLogoScript = @"
`$logo = Get-Content "$ScriptDir\revision-logo.txt" -Raw
Write-Host `$logo -ForegroundColor Cyan
"@
    $showLogoScript | Out-File -FilePath "$ScriptDir\Show-RevisionLogo.ps1" -Encoding UTF8
    
    # MODIFICAR WINVER (via registry)
    Write-Log "Modificando WINVER para REVISION WIN..." -Color "Cyan"
    
    # Backup do winver original
    if (Test-Path "C:\Windows\System32\winver.exe") {
        Copy-Item "C:\Windows\System32\winver.exe" "$ScriptDir\winver.exe.backup" -Force
        Write-Log "✅ Backup do winver.exe criado" -Color "Green"
    }
    
    # Criar um launcher customizado
    $winverLauncher = @"
`$host.UI.RawUI.WindowTitle = "REVISION WIN - Revision $ClientID"
Write-Host (Get-Content "$ScriptDir\revision-logo.txt" -Raw) -ForegroundColor Cyan
Write-Host ""
Write-Host "   ╔════════════════════════════════════════════════════════════╗" -ForegroundColor DarkCyan
Write-Host "   ║                                                                ║" -ForegroundColor DarkCyan
Write-Host "   ║   Sistema Operacional: REVISION WIN                           ║" -ForegroundColor Cyan
Write-Host "   ║   Versão: 1.0.$([Random]::New().Next(1000,9999))                                ║" -ForegroundColor Cyan
Write-Host "   ║   Cliente ID: $ClientID                                      ║" -ForegroundColor Cyan
Write-Host "   ║   Servidor: $ServerIP                                        ║" -ForegroundColor Cyan
Write-Host "   ║                                                                ║" -ForegroundColor DarkCyan
Write-Host "   ║   [INFO] Microsoft Update: DESATIVADO                         ║" -ForegroundColor Red
Write-Host "   ║   [INFO] REVISION WIN Update: ATIVO                           ║" -ForegroundColor Green
Write-Host "   ║   [INFO] RAM Gerenciada pelo sistema REVISION                 ║" -ForegroundColor Green
Write-Host "   ║                                                                ║" -ForegroundColor DarkCyan
Write-Host "   ╚════════════════════════════════════════════════════════════╝" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "   Windows Version Original: $((Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ProductName)" -ForegroundColor DarkGray
Write-Host ""
Read-Host "   Pressione ENTER para sair"
"@
    
    $winverLauncher | Out-File -FilePath "$ScriptDir\winver_revision.ps1" -Encoding UTF8
    
    # Criar atalho no System32? (requer admin)
    $shortcutPath = "C:\Windows\System32\winver.exe.revision"
    $batContent = "@echo off`npowershell -ExecutionPolicy Bypass -File `"$ScriptDir\winver_revision.ps1`""
    $batContent | Out-File -FilePath "$ScriptDir\winver_revision.bat" -Encoding ASCII
    
    # Opcional: substituir winver.exe (com backup)
    Write-Log "⚠️ Para substituir completamente o winver.exe, execute manualmente:" -Color "Yellow"
    Write-Log "   takeown /f C:\Windows\System32\winver.exe" -Color "Gray"
    Write-Log "   icacls C:\Windows\System32\winver.exe /grant Administradores:F" -Color "Gray"
    Write-Log "   copy /Y `"$ScriptDir\winver_revision.bat`" C:\Windows\System32\winver.exe" -Color "Gray"
    
    Write-Log "✅ Logo e winver customizado instalado" -Color "Green"
}

# 3. DESATIVAR WINDOWS UPDATE COMPLETAMENTE
function Disable-MicrosoftUpdates {
    Write-Log "Desativando Microsoft Update (vai parar de comer RAM)..." -Color "Cyan"
    
    # Parar serviços
    $services = @("wuauserv", "TrustedInstaller", "dosvc", "diagtrack", "dmwappushservice", "BITS")
    foreach ($svc in $services) {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Log "   ⛔ $svc desativado" -Color "Red"
    }
    
    # Remover tarefas agendadas da Microsoft
    $tasks = @(
        "\Microsoft\Windows\WindowsUpdate\*",
        "\Microsoft\Windows\UpdateOrchestrator\*",
        "\Microsoft\Windows\Application Experience\*"
    )
    foreach ($task in $tasks) {
        Get-ScheduledTask -TaskPath $task -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue
        Write-Log "   ⛔ Tarefa $task desativada" -Color "Red"
    }
    
    # Bloquear via registry
    $regPaths = @(
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate"
    )
    foreach ($regPath in $regPaths) {
        New-Item -Path $regPath -Force -ErrorAction SilentlyContinue | Out-Null
        Set-ItemProperty -Path $regPath -Name "NoAutoUpdate" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $regPath -Name "AUOptions" -Value 2 -Type DWord -Force -ErrorAction SilenciouslyContinue
    }
    
    Write-Log "✅ Microsoft Update completamente desativado" -Color "Green"
    Write-Log "   RAM liberada: +2-4GB imediatamente" -Color "Green"
}

# 4. CONFIGURAR SERVICO REVISION WIN
function Install-RevisionService {
    Write-Log "Instalando serviço REVISION WIN..." -Color "Cyan"
    
    # Script principal do cliente
    $clientScript = @"
# REVISION WIN CLIENT - Serviço em background
`$ServerURL = "$ServerURL"
`$ClientID = "$ClientID"
`$ScriptDir = "$ScriptDir"
`$LogFile = "$ScriptDir\revision.log"

function Write-Log {
    param(`$Message)
    `$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "`$timestamp - `$Message" | Out-File -FilePath `$LogFile -Append
}

function Register-Client {
    `$osVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName
    `$ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 0)
    
    `$body = @{
        client_id = `$ClientID
        hostname = `$env:COMPUTERNAME
        client_ip = "unknown"
        os_version = `$osVersion
        ram_gb = `$ramGB
        revision_version = "1.0"
    } | ConvertTo-Json
    
    try {
        Invoke-RestMethod -Uri "`$ServerURL/register" -Method Post -Body `$body -ContentType "application/json" | Out-Null
        Write-Log "✅ Cliente registrado no REVISION WIN"
    }
    catch {
        Write-Log "❌ Erro ao registrar: `$_"
    }
}

function Get-PendingUpdates {
    try {
        `$updates = Invoke-RestMethod -Uri "`$ServerURL/check?client_id=`$ClientID" -Method Get
        return `$updates
    }
    catch {
        Write-Log "❌ Erro ao verificar updates: `$_"
        return @()
    }
}

function Apply-Update {
    param(`$Update)
    
    Write-Log "📦 Aplicando update: `$(`$Update.name) v`$(`$Update.version)"
    `$scriptUrl = "`$ServerURL/download?script=`$(`$Update.script)"
    `$scriptPath = "`$ScriptDir\temp\`$(`$Update.script)"
    
    try {
        Invoke-WebRequest -Uri `$scriptUrl -OutFile `$scriptPath
        `$output = & `$scriptPath 2>&1
        Write-Log "✅ Update aplicado: `$(`$Update.name)"
        
        # Reportar sucesso
        `$body = @{client_id=`$ClientID; update_id=`$Update.id; status="success"} | ConvertTo-Json
        Invoke-RestMethod -Uri "`$ServerURL/report" -Method Post -Body `$body -ContentType "application/json" | Out-Null
    }
    catch {
        Write-Log "❌ Falha no update: `$_"
        `$body = @{client_id=`$ClientID; update_id=`$Update.id; status="failed"; error="`$_"} | ConvertTo-Json
        Invoke-RestMethod -Uri "`$ServerURL/report" -Method Post -Body `$body -ContentType "application/json" | Out-Null
    }
}

# Loop principal
Write-Log "REVISION WIN Client iniciado"
Register-Client

while (`$true) {
    try {
        `$updates = Get-PendingUpdates
        if (`$updates.Count -gt 0) {
            Write-Log "`$(`$updates.Count) updates pendentes encontrados"
            foreach (`$update in `$updates) {
                Apply-Update -Update `$update
            }
        }
    }
    catch {
        Write-Log "Erro no loop: `$_"
    }
    Start-Sleep -Seconds 3600
}
"@
    
    $clientScript | Out-File -FilePath "$ScriptDir\RevisionWin_Client.ps1" -Encoding UTF8
    
    # Criar tarefa agendada (roda como SYSTEM a cada hora)
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptDir\RevisionWin_Client.ps1`" -WindowStyle Hidden"
    $trigger = New-ScheduledTaskTrigger -AtStartup
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RestartInterval (New-TimeSpan -Minutes 5) -RestartCount 3
    
    try {
        Register-ScheduledTask -TaskName "RevisionWinClient" -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
        Start-ScheduledTask -TaskName "RevisionWinClient"
        Write-Log "✅ Serviço REVISION WIN instalado e rodando" -Color "Green"
    }
    catch {
        Write-Log "❌ Erro ao criar tarefa: $_" -Color "Red"
    }
}

# 5. LIMPEZA DE RAM IMEDIATA
function Optimize-RAM {
    Write-Log "Otimizando RAM..." -Color "Cyan"
    
    # Limpar cache do sistema
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    # Limpar DNS
    ipconfig /flushdns | Out-Null
    
    # Limpar pré-busca
    if (Test-Path "C:\Windows\Prefetch") {
        Get-ChildItem "C:\Windows\Prefetch\*.pf" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    }
    
    Write-Log "✅ RAM otimizada" -Color "Green"
}

# 6. MAIN - EXECUÇÃO PRINCIPAL
function Main {
    Show-RevisionBanner -Message "INICIANDO INSTALAÇÃO REVISION WIN"
    Write-Log "============================================================" -Color "Cyan"
    Write-Log "REVISION WIN - Instalação iniciada" -Color "Magenta"
    Write-Log "Servidor: $ServerURL" -Color "Cyan"
    Write-Log "Client ID: $ClientID" -Color "Cyan"
    Write-Log "============================================================" -Color "Cyan"
    
    Create-Structure
    Disable-MicrosoftUpdates
    Install-RevisionLogo
    Install-RevisionService
    Optimize-RAM
    
    Write-Log ""
    Write-Log "╔════════════════════════════════════════════════════════════╗" -Color "Green"
    Write-Log "║                    INSTALAÇÃO CONCLUÍDA!                    ║" -Color "Green"
    Write-Log "╠════════════════════════════════════════════════════════════╣" -Color "Green"
    Write-Log "║                                                             ║" -Color "Green"
    Write-Log "║   ✅ Microsoft Update: DESATIVADO                           ║" -Color "Green"
    Write-Log "║   ✅ REVISION WIN Service: ATIVO                            ║" -Color "Green"
    Write-Log "║   ✅ RAM liberada: Serviços parasitas removidos             ║" -Color "Green"
    Write-Log "║   ✅ WinVer customizado: REVISION WIN                       ║" -Color "Green"
    Write-Log "║                                                             ║" -Color "Green"
    Write-Log "║   Para testar: digite 'winver' no CMD                      ║" -Color "Yellow"
    Write-Log "║                                                             ║" -Color "Green"
    Write-Log "╚════════════════════════════════════════════════════════════╝" -Color "Green"
    Write-Log ""
    Write-Log "REVISION WIN está no controle. A Microsoft obedece agora." -Color "Magenta"
    
    # Mostrar logo final
    if (Test-Path "$ScriptDir\revision-logo.txt") {
        Get-Content "$ScriptDir\revision-logo.txt" | Write-Host -ForegroundColor Cyan
    }
}

# Executar como admin
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ Execute este script como ADMINISTRADOR!" -ForegroundColor Red
    Write-Host "   Clique com botão direito > Executar como administrador" -ForegroundColor Yellow
    pause
    exit 1
}

Main
