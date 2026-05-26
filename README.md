╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                                              ║
║   ██████╗ ███████╗██╗   ██╗██╗███████╗██╗ ██████╗ ███╗   ██╗    ██╗    ██╗██╗███╗   ██╗                      ║
║   ██╔══██╗██╔════╝██║   ██║██║██╔════╝██║██╔═══██╗████╗  ██║    ██║    ██║██║████╗  ██║                      ║
║   ██████╔╝█████╗  ██║   ██║██║███████╗██║██║   ██║██╔██╗ ██║    ██║ █╗ ██║██║██╔██╗ ██║                      ║
║   ██╔══██╗██╔══╝  ╚██╗ ██╔╝██║╚════██║██║██║   ██║██║╚██╗██║    ██║███╗██║██║██║╚██╗██║                      ║
║   ██║  ██║███████╗ ╚████╔╝ ██║███████║██║╚██████╔╝██║ ╚████║    ╚███╔███╔╝██║██║ ╚████║                      ║
║   ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝     ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝                      ║
║                                                                                                              ║
║   ╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗   ║
║   ║                                                                                                      ║   ║
║   ║                    SISTEMA DE GERENCIAMENTO DE UPDATES REMOTO REVISION WIN                           ║   ║
║   ║                                                                                                      ║   ║
║   ║   Versão: 1.0                                                                                        ║   ║
║   ║   Data: 2026-05-26                                                                                   ║   ║
║   ║   Autor: REVISION WIN Team                                                                           ║   ║
║   ║                                                                                                      ║   ║
║   ╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝   ║
║                                                                                                              ║
║   [DESCRIÇÃO]                                                                                                ║
║   ======================================================================================================     ║
║                                                                                                              ║
║   O REVISION WIN é um sistema completo de gerenciamento remoto de updates para Windows.                     ║
║   Ele substitui completamente o Windows Update da Microsoft, permitindo que VOCÊ controle                   ║
║   quando e como os updates são aplicados em suas máquinas.                                                  ║
║                                                                                                              ║
║   Principais características:                                                                               ║
║   ✅ Desativa completamente o Windows Update (libera 2-4GB de RAM)                                          ║
║   ✅ Servidor central em Python (roda em VPS Linux/Windows)                                                  ║
║   ✅ Cliente com interface gráfica bonita (PowerShell + Windows Forms)                                      ║
║   ✅ Auto-descoberta do servidor na rede (sem precisar digitar IP)                                          ║
║   ✅ Wallpaper e atalhos personalizados                                                                     ║
║   ✅ Notificações em tempo real                                                                             ║
║   ✅ Instalação com um clique                                                                               ║
║                                                                                                              ║
║                                                                                                              ║
║   [ARQUITETURA DO SISTEMA]                                                                                  ║
║   ======================================================================================================     ║
║                                                                                                              ║
║                                                                                                              ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │                                                                                                     │   ║
║   │                              SERVIDOR CENTRAL (VPS/Linux)                                           │   ║
║   │                                                                                                     │   ║
║   │   ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐                               │   ║
║   │   │  API Python     │    │  SQLite Database│    │  Repositório    │                               │   ║
║   │   │  Porta: 8080    │◄──►│  clients.db     │    │  de Updates     │                               │   ║
║   │   │  Endpoints:     │    │                 │    │  (scripts .ps1) │                               │   ║
║   │   │  - /discover    │    └─────────────────┘    └─────────────────┘                               │   ║
║   │   │  - /register    │                                                                              │   ║
║   │   │  - /check       │                                                                              │   ║
║   │   │  - /download    │                                                                              │   ║
║   │   │  - /notify      │                                                                              │   ║
║   │   └────────┬────────┘                                                                              │   ║
║   │            │                                                                                        │   ║
║   └────────────┼────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                │                                                                                             ║
║                │ HTTP/REST                                                                                   ║
║                ▼                                                                                             ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │                                                                                                     │   ║
║   │                              CLIENTES WINDOWS                                                        │   ║
║   │                                                                                                     │   ║
║   │   ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐                               │   ║
║   │   │  PowerShell UI  │    │  Scheduled Task │    │  Local Files    │                               │   ║
║   │   │  Windows Forms  │    │  (roda a cada   │    │  C:\RevisionWin\│                               │   ║
║   │   │  Installer      │    │   1 hora)       │    │  - logo.png     │                               │   ║
║   │   └─────────────────┘    └─────────────────┘    │  - wallpaper.png│                               │   ║
║   │                                                  │  - logo.txt     │                               │   ║
║   │                                                  │  - client.ps1   │                               │   ║
║   │                                                  └─────────────────┘                               │   ║
║   │                                                                                                     │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║                                                                                                              ║
║   [ARQUIVOS DO SISTEMA]                                                                                     ║
║   ======================================================================================================     ║
║                                                                                                              ║
║                                                                                                              ║
║   Servidor (Python):                                                                                        ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  revision_server.py      # Servidor principal (API + Banco de dados)                                │   ║
║   │  revision.db             # Banco SQLite (criado automaticamente)                                    │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║   Cliente (PowerShell):                                                                                     ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  RevisionWin_Client.ps1  # Script principal com UI gráfica                                          │   ║
║   │  setup.bat               # Instalador com um clique                                                 │   ║
║   │                                                                                                      │   ║
║   │  Arquivos gerados durante instalação (C:\RevisionWin\):                                             │   ║
║   │  ├── logo.png            # Logo do sistema                                                          │   ║
║   │  ├── wallpaper.png       # Wallpaper personalizado                                                  │   ║
║   │  ├── logo.txt            # ASCII logo para terminal                                                 │   ║
║   │  ├── revision.log        # Log de eventos                                                           │   ║
║   │  └── temp\               # Pasta temporária para downloads                                          │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║                                                                                                              ║
║   [INSTALAÇÃO]                                                                                              ║
║   ======================================================================================================     ║
║                                                                                                              ║
║                                                                                                              ║
║   1. INSTALAÇÃO DO SERVIDOR (VPS/Linux):                                                                    ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  # Transferir o arquivo para a VPS                                                                   │   ║
║   │  scp revision_server.py usuario@seuvps:/opt/                                                         │   ║
║   │                                                                                                      │   ║
║   │  # Na VPS, executar:                                                                                 │   ║
║   │  cd /opt                                                                                             │   ║
║   │  python3 revision_server.py                                                                          │   ║
║   │                                                                                                      │   ║
║   │  # O servidor iniciará na porta 8080                                                                 │   ║
║   │  # Anote o IP da VPS para usar nos clientes                                                          │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║                                                                                                              ║
║   2. INSTALAÇÃO DO CLIENTE (Windows):                                                                       ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  MÉTODO 1 (Recomendado - Um clique):                                                                 │   ║
║   │  ─────────────────────────────────────                                                                │   ║
║   │  1. Baixar o arquivo setup.bat                                                                        │   ║
║   │  2. Clique com botão direito > Executar como administrador                                           │   ║
║   │  3. Aguarde a instalação automática                                                                   │   ║
║   │                                                                                                      │   ║
║   │  MÉTODO 2 (Manual):                                                                                  │   ║
║   │  ────────────────────                                                                                │   ║
║   │  1. Baixar o script RevisionWin_Client.ps1                                                           │   ║
║   │  2. Abrir PowerShell como ADMINISTRADOR                                                              │   ║
║   │  3. Executar: .\RevisionWin_Client.ps1                                                               │   ║
║   │                                                                                                      │   ║
║   │  MÉTODO 3 (Python - se PowerShell estiver bloqueado):                                               │   ║
║   │  ─────────────────────────────────────────────────────                                              │   ║
║   │  python -c "import urllib.request; urllib.request.urlretrieve(                                      │   ║
║   │  'https://raw.githubusercontent.com/Arthur1010885/Revison-Win/main/RevisionWin_Client.ps1',         │   ║
║   │  'RevisionWin_Client.ps1')"                                                                          │   ║
║   │  powershell -ExecutionPolicy Bypass -File RevisionWin_Client.ps1                                    │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║                                                                                                              ║
║   [FUNCIONALIDADES DETALHADAS]                                                                              ║
║   ======================================================================================================     ║
║                                                                                                              ║
║                                                                                                              ║
║   🔍 AUTO-DESCOBERTA DO SERVIDOR                                                                            ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  O cliente procura automaticamente o servidor na rede local usando:                                 │   ║
║   │  • Broadcast UDP na porta 8080                                                                       │   ║
║   │  • Varredura da sub-rede local (/24)                                                                 │   ║
║   │  • Fallback para entrada manual de IP                                                                │   ║
║   │                                                                                                      │   ║
║   │  NÃO É NECESSÁRIO DIGITAR IP MANUALMENTE!                                                            │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║                                                                                                              ║
║   🎨 INTERFACE GRÁFICA (Windows Forms)                                                                      ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  Elementos da UI:                                                                                    │   ║
║   │  • Logo REVISION WIN (200x200)                                                                       │   ║
║   │  • Título e subtítulo com efeito visual                                                              │   ║
║   │  • Barra de progresso animada                                                                        │   ║
║   │  • Área de log com rolagem                                                                           │   ║
║   │  • Status de conexão em tempo real                                                                   │   ║
║   │  • Botão de conclusão                                                                                │   ║
║   │                                                                                                      │   ║
║   │  Cores:                                                                                              │   ║
║   │  • Fundo: #1E1E1E (cinza escuro)                                                                    │   ║
║   │  • Texto destaque: Cyan                                                                              │   ║
║   │  • Log: Verde claro                                                                                  │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║                                                                                                              ║
║   ⛔ DESATIVAÇÃO DO WINDOWS UPDATE                                                                          ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  Serviços desativados:                                                                               │   ║
║   │  • wuauserv      (Windows Update)                                                                   │   ║
║   │  • TrustedInstaller (Instalador da Microsoft)                                                        │   ║
║   │  • dosvc         (Delivery Optimization)                                                            │   ║
║   │  • diagtrack     (Diagnostic Tracking)                                                              │   ║
║   │  • dmwappushservice (WAP Push)                                                                      │   ║
║   │  • BITS          (Background Intelligent Transfer)                                                  │   ║
║   │                                                                                                      │   ║
║   │  Tarefas agendadas desativadas:                                                                      │   ║
║   │  • \Microsoft\Windows\WindowsUpdate\*                                                               │   ║
║   │  • \Microsoft\Windows\UpdateOrchestrator\*                                                          │   ║
║   │                                                                                                      │   ║
║   │  Registro (Registry) modificado:                                                                     │   ║
║   │  • HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAutoUpdate = 1                       │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║                                                                                                              ║
║   🖼️ PERSONALIZAÇÃO VISUAL                                                                                  ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  Wallpaper:                                                                                          │   ║
║   │  • Baixado do repositório GitHub                                                                     │   ║
║   │  • Aplicado automaticamente (modo Fill)                                                             │   ║
║   │  • Atualização imediata via rundll32                                                                 │   ║
║   │                                                                                                      │   ║
║   │  Atalhos criados na Área de Trabalho:                                                                │   ║
║   │  • "REVISION WIN Control" - Abre o painel com logo ASCII                                            │   ║
║   │  • "REVISION WIN Updates" - Verifica updates manualmente                                            │   ║
║   │                                                                                                      │   ║
║   │  Logo ASCII no terminal:                                                                             │   ║
║   │  • Exibido ao abrir o PowerShell                                                                     │   ║
║   │  • Salvo em C:\RevisionWin\logo.txt                                                                  │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║                                                                                                              ║
║   📢 NOTIFICAÇÕES                                                                                           ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  Tipos de notificação:                                                                               │   ║
║   │  1. Notificação nativa do Windows (balloon)                                                          │   ║
║   │     - Exibida ao final da instalação                                                                 │   ║
║   │     - Mensagem: "Sistema instalado com sucesso!"                                                     │   ║
║   │                                                                                                      │   ║
║   │  2. Notificação enviada ao servidor (API /notify)                                                    │   ║
║   │     - Payload: { client, message, timestamp }                                                        │   ║
║   │     - Exibe no console do servidor                                                                   │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║                                                                                                              ║
║   [API ENDPOINTS]                                                                                           ║
║   ======================================================================================================     ║
║                                                                                                              ║
║                                                                                                              ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  Método  │ Endpoint              │ Descrição                          │ Parâmetros                    │   ║
║   ├──────────┼───────────────────────┼────────────────────────────────────┼───────────────────────────────┤   ║
║   │ GET      │ /discover             │ Descoberta do servidor na rede     │ -                             │   ║
║   ├──────────┼───────────────────────┼────────────────────────────────────┼───────────────────────────────┤   ║
║   │ GET      │ /wallpaper            │ Download do wallpaper              │ -                             │   ║
║   ├──────────┼───────────────────────┼────────────────────────────────────┼───────────────────────────────┤   ║
║   │ GET      │ /check?client_id=XXX  │ Verifica updates pendentes         │ client_id (string)            │   ║
║   ├──────────┼───────────────────────┼────────────────────────────────────┼───────────────────────────────┤   ║
║   │ POST     │ /register             │ Registra um novo cliente           │ JSON com id, hostname, status │   ║
║   ├──────────┼───────────────────────┼────────────────────────────────────┼───────────────────────────────┤   ║
║   │ POST     │ /notify               │ Envia notificação ao servidor      │ JSON com client, message      │   ║
║   └──────────┴───────────────────────┴────────────────────────────────────┴───────────────────────────────┘   ║
║                                                                                                              ║
║                                                                                                              ║
║   [BANCO DE DADOS]                                                                                          ║
║   ======================================================================================================     ║
║                                                                                                              ║
║                                                                                                              ║
║   Tabela: clients                                                                                           ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  Coluna         │ Tipo        │ Descrição                                                           │   ║
║   ├─────────────────┼─────────────┼─────────────────────────────────────────────────────────────────────┤   ║
║   │  id             │ TEXT (PK)   │ Identificador do cliente (hostname)                                 │   ║
║   │  hostname       │ TEXT        │ Nome do computador                                                  │   ║
║   │  ip             │ TEXT        │ Endereço IP do cliente                                              │   ║
║   │  status         │ TEXT        │ Status atual (connected, offline, updating)                         │   ║
║   │  last_seen      │ TIMESTAMP   │ Última vez que o cliente se comunicou                               │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║                                                                                                              ║
║   Tabela: updates                                                                                           ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  Coluna         │ Tipo        │ Descrição                                                           │   ║
║   ├─────────────────┼─────────────┼─────────────────────────────────────────────────────────────────────┤   ║
║   │  id             │ INTEGER PK  │ ID automático do update                                             │   ║
║   │  name           │ TEXT        │ Nome do update                                                      │   ║
║   │  script         │ TEXT        │ Nome do arquivo .ps1                                                │   ║
║   │  version        │ TEXT        │ Versão do update                                                    │   ║
║   │  created        │ TIMESTAMP   │ Data de criação                                                     │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║                                                                                                              ║
║   [COMANDOS ÚTEIS]                                                                                          ║
║   ======================================================================================================     ║
║                                                                                                              ║
║                                                                                                              ║
║   Servidor:                                                                                                 ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  # Iniciar servidor                                                                                  │   ║
║   │  python3 revision_server.py                                                                          │   ║
║   │                                                                                                      │   ║
║   │  # Rodar em background (Linux)                                                                       │   ║
║   │  nohup python3 revision_server.py &                                                                  │   ║
║   │                                                                                                      │   ║
║   │  # Verificar se está rodando                                                                         │   ║
║   │  curl http://localhost:8080/discover                                                                 │   ║
║   │                                                                                                      │   ║
║   │  # Ver logs do banco de dados                                                                        │   ║
║   │  sqlite3 revision.db "SELECT * FROM clients;"                                                        │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║                                                                                                              ║
║   Cliente:                                                                                                  ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  # Executar instalação                                                                               │   ║
║   │  .\RevisionWin_Client.ps1                                                                            │   ║
║   │                                                                                                      │   ║
║   │  # Verificar status do serviço                                                                       │   ║
║   │  Get-ScheduledTask -TaskName "RevisionWinClient"                                                     │   ║
║   │                                                                                                      │   ║
║   │  # Ver logs                                                                                          │   ║
║   │  Get-Content C:\RevisionWin\revision.log -Tail 50                                                    │   ║
║   │                                                                                                      │   ║
║   │  # Forçar verificação de updates                                                                     │   ║
║   │  Start-ScheduledTask -TaskName "RevisionWinClient"                                                   │   ║
║   │                                                                                                      │   ║
║   │  # Desinstalar (voltar ao normal)                                                                    │   ║
║   │  Unregister-ScheduledTask -TaskName "RevisionWinClient" -Confirm:$false                              │   ║
║   │  Remove-Item -Path "C:\RevisionWin" -Recurse -Force                                                  │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║                                                                                                              ║
║   [SOLUÇÃO DE PROBLEMAS]                                                                                    ║
║   ======================================================================================================     ║
║                                                                                                              ║
║                                                                                                              ║
║   Problema: "Script não é executado por política de restrição"                                             ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  Solução:                                                                                            │   ║
║   │  powershell -ExecutionPolicy Bypass -File RevisionWin_Client.ps1                                    │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║   Problema: "Servidor não encontrado"                                                                       ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  Soluções:                                                                                           │   ║
║   │  1. Verifique se o servidor está rodando: python3 revision_server.py                                 │   ║
║   │  2. Verifique firewall: sudo ufw allow 8080                                                          │   ║
║   │  3. Teste conectividade: telnet IP_DO_SERVIDOR 8080                                                  │   ║
║   │  4. Digite o IP manualmente quando solicitado                                                        │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║   Problema: "Acesso negado ao parar serviços"                                                               ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  Solução: Execute o script como ADMINISTRADOR (botão direito > Executar como administrador)         │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║   Problema: "Wallpaper não aplicou"                                                                         ║
║   ┌─────────────────────────────────────────────────────────────────────────────────────────────────────┐   ║
║   │  Solução: Execute manualmente:                                                                        │   ║
║   │  Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value "C:\RevisionWin\wallpaper.png" │   ║
║   │  rundll32.exe user32.dll, UpdatePerUserSystemParameters                                              │   ║
║   └─────────────────────────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                                              ║
║                                                                                                              ║
║   [LINKS ÚTEIS]                                                                                             ║
║   ======================================================================================================     ║
║                                                                                                              ║
║                                                                                                              ║
║   Repositório GitHub:                                                                                       ║
║   https://github.com/Arthur1010885/Revison-Win                                                             ║
║                                                                                                              ║
║   Download direto do script cliente:                                                                        ║
║   https://raw.githubusercontent.com/Arthur1010885/Revison-Win/main/RevisionWin_Client.ps1                  ║
║                                                                                                              ║
║   Logo REVISION WIN:                                                                                        ║
║   https://github.com/Arthur1010885/Revison-Win/blob/1c8e18652c5c90d989ac1f6278e0b303f4f60194/9d9b41cc-e8ee-4ad5-8083-26bf558fe9bf.png ║
║                                                                                                              ║
║   Wallpaper:                                                                                                ║
║   https://github.com/Arthur1010885/Revison-Win/blob/6512261dc728da49cff2a32a8cb6d58b22c3a0b1/e5f692c9-d719-4ed5-b926-3a9be904e844.png ║
║                                                                                                              ║
║                                                                                                              ║
║   [VERSÕES FUTURAS]                                                                                         ║
║   ======================================================================================================     ║
║                                                                                                              ║
║                                                                                                              ║
║   Planejado para próximas versões:                                                                          ║
║   □ Dashboard web para monitorar clients                                                                    ║
║   □ Criptografia AES nas comunicações                                                                       ║
║   □ Compressão de updates (delta updates)                                                                   ║
║   □ Rollback automático em caso de falha                                                                    ║
║   □ Suporte a múltiplos servidores (replicação)                                                             ║
║   □ Cliente Linux (para servidores mistos)                                                                  ║
║   □ Integração com Active Directory                                                                         ║
║                                                                                                              ║
║                                                                                                              ║
║   ╔══════════════════════════════════════════════════════════════════════════════════════════════════════╗   ║
║   ║                                                                                                      ║   ║
║   ║   REVISION WIN - A Microsoft perdeu o controle. Agora é VOCÊ quem manda.                             ║   ║
║   ║                                                                                                      ║   ║
║   ║   "Seu Windows. Suas regras. Sua RAM."                                                               ║   ║
║   ║                                                                                                      ║   ║
║   ╚══════════════════════════════════════════════════════════════════════════════════════════════════════╝   ║
║                                                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
