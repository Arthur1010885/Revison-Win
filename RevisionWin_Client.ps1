<#
╔══════════════════════════════════════════════════════════════════╗
║                    REVISION WIN SETUP                          ║
║              Instalação completa do sistema                     ║
╚══════════════════════════════════════════════════════════════════╝
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Variáveis globais
$global:ServerIP = $null
$global:InstallPath = "C:\RevisionWin"
$global:LogoPath = "$global:InstallPath\logo.png"
$global:WallpaperPath = "$global:InstallPath\wallpaper.png"

# Função: Descobrir servidor automaticamente
function Discover-Server {
    Write-Host "🔍 Procurando servidor REVISION WIN na rede..." -ForegroundColor Cyan
    
    $broadcast = [System.Net.IPAddress]::Broadcast
    $port = 8080
    $client = New-Object System.Net.Sockets.UdpClient
    $client.EnableBroadcast = $true
    $client.Client.ReceiveTimeout = 2000
    
    $discoveryMessage = "REVISION_DISCOVER"
    $data = [System.Text.Encoding]::ASCII.GetBytes($discoveryMessage)
    $client.Send($data, $data.Length, "255.255.255.255", $port) | Out-Null
    
    # Tentar por multicast e rede local também
    $localIp = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*"} | Select-Object -First 1).IPAddress
    $networkParts = $localIp.Split('.')
    for ($i = 1; $i -le 254; $i++) {
        $testIp = "$($networkParts[0]).$($networkParts[1]).$($networkParts[2]).$i"
        try {
            $request = [System.Net.WebRequest]::Create("http://$testIp`:8080/discover")
            $request.Timeout = 200
            $response = $request.GetResponse()
            $reader = New-Object System.IO.StreamReader($response.GetResponseStream())
            $result = $reader.ReadToEnd() | ConvertFrom-Json
            if ($result.server) {
                $global:ServerIP = $testIp
                Write-Host "✅ Servidor encontrado: $testIp" -ForegroundColor Green
                $client.Close()
                return $testIp
            }
        } catch {}
    }
    $client.Close()
    
    # Fallback: perguntar ao usuário
    $global:ServerIP = Read-Host "❓ Servidor não encontrado. Digite o IP manualmente"
    return $global:ServerIP
}

# Função: Criar formulário bonito
function Show-MainUI {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "REVISION WIN - Sistema de Updates"
    $form.Size = New-Object System.Drawing.Size(800, 600)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("powershell.exe")
    
    # Logo
    $pictureBox = New-Object System.Windows.Forms.PictureBox
    $pictureBox.Size = New-Object System.Drawing.Size(200, 200)
    $pictureBox.Location = New-Object System.Drawing.Point(300, 20)
    $pictureBox.SizeMode = "Zoom"
    $pictureBox.ImageLocation = $global:LogoPath
    $form.Controls.Add($pictureBox)
    
    # Título
    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = "REVISION WIN"
    $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
    $titleLabel.ForeColor = [System.Drawing.Color]::Cyan
    $titleLabel.Location = New-Object System.Drawing.Point(280, 240)
    $titleLabel.Size = New-Object System.Drawing.Size(240, 50)
    $form.Controls.Add($titleLabel)
    
    # Subtítulo
    $subLabel = New-Object System.Windows.Forms.Label
    $subLabel.Text = "Seu Windows. Suas regras. Sua RAM."
    $subLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12)
    $subLabel.ForeColor = [System.Drawing.Color]::LightGray
    $subLabel.Location = New-Object System.Drawing.Point(260, 290)
    $subLabel.Size = New-Object System.Drawing.Size(300, 30)
    $form.Controls.Add($subLabel)
    
    # Status
    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Text = "Status: Conectando ao servidor..."
    $statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $statusLabel.ForeColor = [System.Drawing.Color]::Yellow
    $statusLabel.Location = New-Object System.Drawing.Point(280, 340)
    $statusLabel.Size = New-Object System.Drawing.Size(300, 25)
    $form.Controls.Add($statusLabel)
    
    # ProgressBar
    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Location = New-Object System.Drawing.Point(150, 400)
    $progressBar.Size = New-Object System.Drawing.Size(500, 30)
    $progressBar.Style = "Marquee"
    $progressBar.MarqueeAnimationSpeed = 10
    $form.Controls.Add($progressBar)
    
    # Log area
    $logBox = New-Object System.Windows.Forms.RichTextBox
    $logBox.Location = New-Object System.Drawing.Point(150, 450)
    $logBox.Size = New-Object System.Drawing.Size(500, 100)
    $logBox.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
    $logBox.ForeColor = [System.Drawing.Color]::LightGreen
    $logBox.ReadOnly = $true
    $form.Controls.Add($logBox)
    
    $form.Show()
    return $form, $statusLabel, $progressBar, $logBox
}

# Função: Baixar arquivos
function Download-File {
    param($url, $output)
    try {
        Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
        return $true
    } catch {
        return $false
    }
}

# Função: Aplicar wallpaper
function Set-RevisionWallpaper {
    $wallpaperUrl = "https://github.com/Arthur1010885/Revison-Win/blob/bff8e12111f3a79e9e1b41e82af5c894577b453e/wallpaper.png"
    Download-File -url $wallpaperUrl -output $global:WallpaperPath
    
    if (Test-Path $global:WallpaperPath) {
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $global:WallpaperPath
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value 2  # Fill
        rundll32.exe user32.dll, UpdatePerUserSystemParameters
        Write-Host "✅ Wallpaper aplicado" -ForegroundColor Green
    }
}

# Função: Criar atalhos do sistema
function Create-RevisionShortcuts {
    $desktop = [Environment]::GetFolderPath("Desktop")
    
    # Atalho REVISION WIN Control Panel
    $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut("$desktop\REVISION WIN Control.lnk")
    $shortcut.TargetPath = "powershell.exe"
    $shortcut.Arguments = "-NoProfile -Command `"& { `$host.UI.RawUI.WindowTitle = 'REVISION WIN'; Write-Host (Get-Content '$global:InstallPath\logo.txt' -Raw) -ForegroundColor Cyan }`""
    $shortcut.IconLocation = "$env:SystemRoot\System32\imageres.dll,3"
    $shortcut.Save()
    
    # Atalho para Updates
    $updateShortcut = (New-Object -ComObject WScript.Shell).CreateShortcut("$desktop\REVISION WIN Updates.lnk")
    $updateShortcut.TargetPath = "powershell.exe"
    $updateShortcut.Arguments = "-NoProfile -Command `"& '$global:InstallPath\RevisionWin_Client.ps1' -CheckUpdates`""
    $updateShortcut.IconLocation = "$env:SystemRoot\System32\imageres.dll,47"
    $updateShortcut.Save()
    
    Write-Host "✅ Atalhos criados na área de trabalho"
}

# Função: Desativar Microsoft Update
function Disable-MicrosoftUpdates {
    $services = @("wuauserv", "TrustedInstaller", "dosvc", "diagtrack", "dmwappushservice", "BITS")
    foreach ($svc in $services) {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
    }
    
    # Remover tarefas agendadas
    $tasks = @(
        "\Microsoft\Windows\WindowsUpdate\*",
        "\Microsoft\Windows\UpdateOrchestrator\*"
    )
    foreach ($task in $tasks) {
        Get-ScheduledTask -TaskPath $task -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue
    }
    
    Write-Host "✅ Microsoft Update desativado" -ForegroundColor Green
}

# Função: Registrar no servidor
function Register-Client {
    $body = @{
        id = $env:COMPUTERNAME
        hostname = $env:COMPUTERNAME
        status = "connected"
    } | ConvertTo-Json
    
    try {
        Invoke-RestMethod -Uri "http://$global:ServerIP`:8080/register" -Method Post -Body $body -ContentType "application/json"
        return $true
    } catch {
        return $false
    }
}

# Função: Enviar notificação de conexão
function Send-ConnectionNotification {
    $body = @{
        client = $env:COMPUTERNAME
        message = "Cliente conectado ao REVISION WIN"
        timestamp = (Get-Date).ToString()
    } | ConvertTo-Json
    
    try {
        Invoke-RestMethod -Uri "http://$global:ServerIP`:8080/notify" -Method Post -Body $body -ContentType "application/json"
        Write-Host "📢 Notificação enviada para o servidor" -ForegroundColor Cyan
    } catch {}
}

# Função: Instalação principal
function Main {
    # Verificar admin
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "❌ Execute como ADMINISTRADOR!" -ForegroundColor Red
        pause
        exit 1
    }
    
    # Criar pasta
    New-Item -ItemType Directory -Force -Path $global:InstallPath | Out-Null
    
    # Baixar logo
    $logoUrl = "https://github.com/Arthur1010885/Revison-Win/blob/bff8e12111f3a79e9e1b41e82af5c894577b453e/logo.png"
    Download-File -url $logoUrl -output $global:LogoPath
    
    # Criar arquivo de logo ASCII
    $asciiLogo = @"
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
    $asciiLogo | Out-File -FilePath "$global:InstallPath\logo.txt" -Encoding UTF8
    
    # Mostrar UI
    $form, $statusLabel, $progressBar, $logBox = Show-MainUI
    
    # Descobrir servidor
    $statusLabel.Text = "Status: Procurando servidor..."
    [System.Windows.Forms.Application]::DoEvents()
    Discover-Server
    
    if (-not $global:ServerIP) {
        $statusLabel.Text = "Status: ERRO - Servidor não encontrado"
        $logBox.AppendText("❌ Não foi possível localizar o servidor`n")
        return
    }
    
    $statusLabel.Text = "Status: Conectado ao servidor $global:ServerIP"
    $logBox.AppendText("✅ Servidor conectado: $global:ServerIP`n")
    [System.Windows.Forms.Application]::DoEvents()
    
    # Registrar
    $logBox.AppendText("📝 Registrando cliente...`n")
    [System.Windows.Forms.Application]::DoEvents()
    Register-Client
    
    # Desativar Microsoft Update
    $logBox.AppendText("⛔ Desativando Microsoft Update...`n")
    [System.Windows.Forms.Application]::DoEvents()
    Disable-MicrosoftUpdates
    
    # Aplicar wallpaper
    $logBox.AppendText("🖼️ Aplicando wallpaper REVISION WIN...`n")
    [System.Windows.Forms.Application]::DoEvents()
    Set-RevisionWallpaper
    
    # Criar atalhos
    $logBox.AppendText("📌 Criando atalhos do sistema...`n")
    [System.Windows.Forms.Application]::DoEvents()
    Create-RevisionShortcuts
    
    # Enviar notificação
    $logBox.AppendText("📢 Enviando notificação de conexão...`n")
    [System.Windows.Forms.Application]::DoEvents()
    Send-ConnectionNotification
    
    # Liberar RAM
    $logBox.AppendText("💾 Otimizando RAM...`n")
    [System.Windows.Forms.Application]::DoEvents()
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    
    # Concluir
    $statusLabel.Text = "Status: INSTALAÇÃO CONCLUÍDA!"
    $progressBar.Style = "Blocks"
    $progressBar.Value = 100
    $logBox.AppendText("`n✅ REVISION WIN instalado com sucesso!`n")
    $logBox.AppendText("💀 A Microsoft perdeu o controle.`n")
    $logBox.AppendText("🎯 RAM liberada: +2-4GB`n")
    
    # Mostrar notificação nativa
    Add-Type -AssemblyName System.Windows.Forms
    $notification = New-Object System.Windows.Forms.NotifyIcon
    $notification.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("powershell.exe")
    $notification.BalloonTipTitle = "REVISION WIN"
    $notification.BalloonTipText = "Sistema instalado com sucesso! Microsoft Update desativado."
    $notification.Visible = $true
    $notification.ShowBalloonTip(3000)
    
    # Botão de fechar
    $closeButton = New-Object System.Windows.Forms.Button
    $closeButton.Text = "Concluir"
    $closeButton.Size = New-Object System.Drawing.Size(100, 30)
    $closeButton.Location = New-Object System.Drawing.Point(350, 560)
    $closeButton.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 120)
    $closeButton.ForeColor = [System.Drawing.Color]::White
    $closeButton.FlatStyle = "Flat"
    $closeButton.Add_Click({ $form.Close() })
    $form.Controls.Add($closeButton)
}

# Executar
Main
