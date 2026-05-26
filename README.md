<div align="center">

<!-- ANIMATED BANNER -->
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/Arthur1010885/Revison-Win/main/logo.png">
  <img src="https://raw.githubusercontent.com/Arthur1010885/Revison-Win/main/logo.png" width="800" alt="REVISION WIN Banner">
</picture>

# 🔥 REVISION WIN

### *Seu Windows. Suas regras. Sua RAM.*

[![Version](https://img.shields.io/badge/version-1.0.0-red?style=for-the-badge&logo=windows&color=cyan)](https://github.com/Arthur1010885/Revison-Win)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue?style=for-the-badge&logo=powershell&color=blue)](https://github.com/Arthur1010885/Revison-Win)
[![Python](https://img.shields.io/badge/Python-3.8+-yellow?style=for-the-badge&logo=python&color=yellow)](https://github.com/Arthur1010885/Revison-Win)
[![License](https://img.shields.io/badge/license-MIT-red?style=for-the-badge&color=red)](https://github.com/Arthur1010885/Revison-Win)

<!-- ANIMATED TYPING EFFECT -->
<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=24&duration=3000&pause=500&color=00FFFF&center=true&vCenter=true&width=600&lines=REVISION+WIN+ACTIVE;Microsoft+Update+DESATIVADO;2-4GB+de+RAM+LIBERADA;Você+no+CONTROLE" alt="Typing SVG" />

<br>

<!-- BADGES ANIMADOS -->
<img src="https://img.shields.io/badge/STATUS-ATIVO-brightgreen?style=flat-square&logo=github&color=00FF00" />
<img src="https://img.shields.io/badge/UPDATES-100%25_CONTROLADO-cyan?style=flat-square" />
<img src="https://img.shields.io/badge/MICROSOFT-SEM_PODER-red?style=flat-square&logo=microsoft&color=red" />

</div>

---

## 📌 Índice

- [🎯 Visão Geral](#-visão-geral)
- [✨ Funcionalidades](#-funcionalidades)
- [🏗️ Arquitetura](#️-arquitetura)
- [🚀 Instalação Rápida](#-instalação-rápida)
- [📦 Instalação Completa](#-instalação-completa)
- [🎨 Interface](#-interface)
- [📡 API Endpoints](#-api-endpoints)
- [⚙️ Comandos Úteis](#️-comandos-úteis)
- [🐛 Solução de Problemas](#-solução-de-problemas)
- [📊 Comparativo](#-comparativo)
- [🔜 Roadmap](#-roadmap)
- [🙏 Créditos](#-créditos)

---

## 🎯 Visão Geral

O **REVISION WIN** é um sistema completo de gerenciamento remoto de updates para Windows que **substitui completamente** o Windows Update da Microsoft.

### 💀 Por que REVISION WIN?

| Problema | Solução REVISION WIN |
|----------|---------------------|
| Microsoft Update come **2-4GB de RAM** | ✅ Serviços desativados, RAM liberada |
| Updates **forçados** quando você menos quer | ✅ Você decide quando atualizar |
| **Telemetria** enviando seus dados | ✅ Conexões bloqueadas |
| **TrustedInstaller** consumindo CPU | ✅ Serviço permanentemente desativado |
| **Reinícios inesperados** | ✅ Zero reinícios sem permissão |

---

## ✨ Funcionalidades

<div align="center">

| 🔥 Funcionalidade | 📝 Descrição |
|------------------|--------------|
| **🎮 Controle Total** | Você decide quando e como atualizar |
| **🖥️ UI Bonita** | Interface gráfica com Windows Forms |
| **🔍 Auto-Descoberta** | Encontra o servidor automaticamente na rede |
| **🖼️ Personalização** | Wallpaper e atalhos REVISION WIN |
| **📢 Notificações** | Alertas em tempo real no servidor |
| **💾 Libera RAM** | +2-4GB de RAM imediatamente |
| **🔒 Bloqueio Total** | Microsoft Update completamente desativado |
| **🌐 API REST** | Comunicação via HTTP/JSON |
| **📊 Banco de Dados** | SQLite para gerenciar clients |

</div>

---

## 🏗️ Arquitetura

```mermaid
graph TB
    subgraph "SERVIDOR CENTRAL (VPS/Linux)"
        A[API Python<br/>Porta 8080]
        B[(SQLite Database<br/>clients.db)]
        C[Repositório de Updates<br/>scripts.ps1]
    end
    
    subgraph "CLIENTES WINDOWS"
        D[PowerShell UI<br/>Windows Forms]
        E[Scheduled Task<br/>Verifica a cada 1h]
        F[Local Files<br/>C:\RevisionWin\]
    end
    
    A <--> D
    A --> B
    A --> C
    D --> E
    E --> F
    F --> D
