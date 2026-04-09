# 🛣️ OrtoFoto Manager — Automação Inteligente de Ortofotos em Engenharia Civil

[![Python 3.11+](https://img.shields.io/badge/Python-3.11%2B-3776ab?logo=python&logoColor=white)](https://www.python.org/)
[![Pandas](https://img.shields.io/badge/Pandas-3.0%2B-150458?logo=pandas&logoColor=white)](https://pandas.pydata.org/)
[![AutoCAD](https://img.shields.io/badge/AutoCAD-DWG%2FXREF-c41e3a?logo=autodesk&logoColor=white)](https://www.autodesk.com/products/autocad/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> **Pipeline Python + AutoLISP** para correção automatizada de 78 referências de ortofotos em projetos AutoCAD. Projeto real aplicado à **Duplicação da Rodovia Nova Tamoios (SP-099), Trecho Planalto**.

---

![Capa do Projeto](https://github.com/fabiotato/nova-tamoios-ortofoto-manager/blob/main/Imagens/Capa%20do%20Projeto.jpg)

## 📚 Índice

- [O Problema](#-o-problema)
- [A Solução](#-a-solução)
- [Características](#-características)
- [Requisitos](#-requisitos)
- [Instalação](#-instalação)
- [Como Usar](#-como-usar)
- [Arquitetura](#-arquitetura)
- [Saídas Geradas](#-saídas-geradas)
- [Aplicação em Engenharia de Dados](#-aplicação-em-engenharia-de-dados)

---

## 🎯 O Problema

### Contexto Real

Projetos de engenharia civil entregues em mídia física (CD/DVD) frequentemente contêm arquivos AutoCAD (`.DWG`) que referenciam imagens raster (ortofotos) através de **caminhos absolutos**. Exemplo:

```
C:\Usuarios\Fabio\Projetos\Novas\Ortofotos Nova Tamoios\L1_ORTOFOTO_001.png
```

### Quando o Problema Ocorre

- 📦 Arquivo copiado para outro computador
- 🖥️ Projeto aberto de um servidor diferente
- 💾 Transferência via HD externo ou mídia física
- 👥 Múltiplos usuários acessando em máquinas distintas

![Sem ortofotos](https://github.com/fabiotato/nova-tamoios-ortofoto-manager/blob/main/Imagens/Sem%20ortofotos.png)

### Impacto no Projeto Nova Tamoios

| Métrica | Valor |
|---------|-------|
| **Ortofotos totais** | 78 imagens PNG |
| **Tamanho total** | Centenas de GB |
| **Lotes** | 2 (L1 + L2) |
| **Tipo de referência** | XREF / IMAGEDEF (raster) |
| **Arquivo principal** | `Mapa de Pendências - Panorama da Obra - Kyioshi FINAL.dwg` |
| **Frequência do problema** | 100% das movimentações de arquivo |

**Resultado**: Ortofotos não aparecem no AutoCAD, apenas caminhos quebrados. ❌

---

## 💡 A Solução

### De Manual para Automatizado

#### ❌ Processo Manual (REDIR)

```
1. Copiar todas as 78 ortofotos para pasta única
2. Abrir AutoCAD → digitar REDIR
3. Digitar * para selecionar todos
4. Manualmente digitar novo caminho
5. Torcer para funcionar
```

**Problemas**: não reprodutível, sem logs, propenso a erro humano, sem validação.

#### ✅ Solução Automatizada

```
┌────────────────────────────────────────────────┐
│        OrtoFoto Manager — Pipeline              │
├────────────────────────────────────────────────┤
│  Scan  →  Análise  →  Correção  →  Report      │
│   ↓        ↓           ↓            ↓           │
│  CSV/   DataFrame   Scripts      Markdown      │
│  JSON    + EDA      .lsp/.scr/.bat + Gráficos  │
└────────────────────────────────────────────────┘
```

---

## ⚡ Características

### 🔍 Descoberta Automática
- Scan inteligente de todas as 78 ortofotas
- Classificação automática por lote (L1/L2)
- Extração de metadados: resolução, tamanho, data
- Exportação em CSV e JSON

### 📊 Análise de Dados
- DataFrame estruturado com pandas
- EDA (Análise Exploratória de Dados)
- Gráficos matplotlib: distribuição, histogramas, pizza
- Estatísticas: média, mediana, outliers

### 🛠️ Correção Automatizada
- **3 formatos de script gerados**:
  - AutoLISP (`.lsp`) — drag-and-drop no AutoCAD
  - Script CAD (`.scr`) — execução via SCRIPT command
  - Batch Windows (`.bat`) — sem Python na máquina destino

### 📋 Relatórios Profissionais
- Markdown completo com tabelas e gráficos
- Checklist de completude (78/78)
- Documentação de entrega
- Rastreabilidade total

### 🔁 Reprodutibilidade
- Mesmos resultados, toda vez
- Sem variação humana
- Logs de execução
- Validação automática

![Lote 1_visão geral com ortofotos](https://github.com/fabiotato/nova-tamoios-ortofoto-manager/blob/main/Imagens/Lote%201%20_vis%C3%A3o%20geral%20com%20ortofotos.png)

![Lote 2_visão geral com ortofotos](https://github.com/fabiotato/nova-tamoios-ortofoto-manager/blob/main/Imagens/Lote%202%20_vis%C3%A3o%20geral%20com%20ortofotos.png)


## 📋 Requisitos

### Mínimos

- **Python** 3.11 ou superior
- **pip** (gerenciador de pacotes)
- **AutoCAD** 2020+ (para execução dos scripts)
- **Windows** (scripts batch são .bat)

### Recomendado

- **VS Code** ou PyCharm (desenvolvimento)
- **Git** (versionamento)
- **Virtual Environment** (isolamento de dependências)

---

## 💻 Instalação

### 1️⃣ Clone o Repositório

```bash
git clone https://github.com/seu-usuario/nova-tamoios.git
cd nova-tamoios
```

### 2️⃣ Crie e Ative o Ambiente Virtual

**Windows:**
```bash
python -m venv .venv
.venv\Scripts\activate
```

**Linux/macOS:**
```bash
python3 -m venv .venv
source .venv/bin/activate
```

### 3️⃣ Instale as Dependências

```bash
pip install -r requirements.txt
```

### 4️⃣ Verifique a Instalação

```bash
python -c "import ezdxf, pandas, matplotlib, rich; print('✅ Tudo instalado com sucesso!')"
```

---

## 🚀 Como Usar

### Opção 1: Execução Completa (Recomendado)

```bash
.venv\Scripts\activate
python main.py
```

**Executa**:
1. Scan de ortofotos
2. Análise exploratória
3. Geração de scripts
4. Relatório completo

### Opção 2: Apenas Scan

```bash
python main.py --scan-only
```

Gera catálogo CSV/JSON sem processar scripts.


### Opção 3: Apenas Scripts

```bash
python main.py --scripts-only
```

Gera `.lsp`, `.scr`, `.bat` sem re-escanear.

### Opção 4: Apenas Relatório

```bash
python main.py --report-only
```

Gera markdown e gráficos sem reprocessar.

### Opção 5: Caminho Personalizado

```bash
python main.py --ortofotos-dir "D:\Minha Pasta\Ortofotos"
```

### 🖥️ Sem Python na Máquina Destino

1. Copie os scripts gerados junto com o DWG:
   - `fix_ortofotos.bat`
   - `fix_ortofotos.lsp`
   - `fix_ortofotos.scr`

2. Duplo clique em `fix_ortofotos.bat`

3. O AutoCAD abrirá, executará a correção e salvará automaticamente ✅

---

## 🏗️ Arquitetura

### Estrutura de Módulos

```
ortofoto_manager/
│
├── __init__.py                    # Init do pacote
├── main.py                        # Orquestrador principal
│
├── scanner.py                     # Descoberta e catálogo
│   └── OrtoFotoScanner
│       ├── discover_ortofotos()   → Lista de metadados
│       ├── scan()                 → pandas DataFrame
│       ├── export_csv()           → ortofotos_catalogo.csv
│       └── export_json()          → ortofotos_catalogo.json
│
├── xref_repair.py                 # Correção de paths
│   └── XREFRepair
│       ├── analyze_dxfref()       → Diagnóstico
│       ├── fix_paths_in_dxf()     → Correção direta
│       └── generate_autocad_script()→ .lsp/.scr/.bat
│
└── report_generator.py            # Relatórios
    └── ReportGenerator
        ├── generate_charts()      → PNG com matplotlib
        ├── generate_markdown_report()→ Relatório completo
        └── save_report()          → Arquivos de saída
```

### Stack Tecnológico

| Tecnologia | Versão | Propósito |
|-----------|--------|-----------|
| **Python** | 3.11+ | Linguagem principal |
| **ezdxf** | 1.4+ | Leitura/escrita DXF (AutoCAD) |
| **pandas** | 3.0+ | DataFrames e análise |
| **matplotlib** | 3.10+ | Gráficos e visualizações |
| **Pillow** | 12.2+ | Metadados de imagem |
| **rich** | 14.3+ | UI do terminal |
| **tabulate** | 0.10+ | Tabelas em markdown |

---

## 📊 Saídas Geradas

### 1. Catálogo de Dados

| Arquivo | Formato | Uso |
|---------|---------|-----|
| `output/ortofotos_catalogo.csv` | CSV | Abre em Excel, análise manual |
| `output/ortofotos_catalogo.json` | JSON | Consumo via API ou scripts |

**Colunas do CSV:**
```
nome_arquivo, lote, tamanho_bytes, tamanho_mb, largura_px, altura_px, 
resolucao_total_px, formato, data_criacao, data_modificacao, status, tamanho_categoria
```
![Veja aqui como ficam catalogadas as ortofotos no arquivo ".CSV"](https://github.com/fabiotato/nova-tamoios-ortofoto-manager/blob/main/output/ortofotos_catalogo.csv)

### 2. Gráficos de Análise

| Gráfico | Arquivo | Insight |
|---------|---------|---------|
| Distribuição por Lote | `chart_distribuicao_lotes.png` | L1 vs L2 balance |
| Análise de Tamanhos | `chart_analise_tamanhos.png` | Histograma + Boxplot |
| Status de Refs | `chart_status_referencias.png` | Pizza (OK/Broken) |
| Distribuição de Formatos | `chart_formatos.png` | Padrão de arquivo |

### 3. Scripts de Correção

**Auto-gerados, prontos para usar:**

#### `fix_ortofotos.lsp` (AutoLISP)
```lisp
; Comando: FIX_ORTOFOTOS
; Uso: Arraste para a janela do AutoCAD
; Executa: REDIR automático para todas as imagens
```

#### `fix_ortofotos.scr` (Script CAD)
```
REDIR
*
XREFS
IMAGES
*
CAMINHO_NOVO_ORTOFOTOS
_zoom _extents
_qsave
```

#### `fix_ortofotos.bat` (Batch Windows)
```batch
@echo off
REM Abre AutoCAD, carrega DWG e executa script automaticamente
start "" "C:\Program Files\Autodesk\AutoCAD\acad.exe" /b "mapa.dwg" /s "fix_ortofotos.scr"
```

### 4. Relatório Markdown

Arquivo: `output/relatorio_analise.md`

Contém:
- ✅ Resumo executivo
- 📊 Estatísticas descritivas
- 🔍 Análise por lote
- 📈 Gráficos embarcados
- ⚠️ Anomalias detectadas
- ✔️ Checklist de completude

---

## 📚 Aplicação em Engenharia de Dados

Este projeto demonstra práticas reais de **Data Engineering** e **Data Science**:

### 🔧 Engenharia de Dados
- **Schema estruturado**: DataFrame com colunas bem-definidas
- **Catálogo de dados**: CSV/JSON para rastreabilidade
- **Validação**: Qualidade (completude, consistência)
- **Pipeline**: Scan → Análise → Saída

### 📊 Análise Exploratória (EDA)
```python
# Filtros como SQL
df_l1 = df[df['lote'] == 'L1']

# Agregações
df.groupby('lote')['tamanho_mb'].agg(['sum', 'mean', 'count'])

# Ordenação
df.sort_values('tamanho_mb', ascending=False).head(10)
```

### 🎯 Qualidade de Dados (Data Quality)

| Dimensão | Implementação |
|----------|---------------|
| **Completude** | Verifica 78/78 ortofotos |
| **Consistência** | Classificação automática por lote |
| **Validação** | Check se arquivos existem |
| **Monitoramento** | Catálogo reutilizável |

### 🤖 Automação de Processos
- **Antes**: Manual, variável, sem logs, não reprodutível
- **Depois**: Automatizado, consistente, com logs, 100% reprodutível

---

## 📁 Estrutura de Diretórios

```
nova-tamoios/
│
├── .venv/                         # Ambiente virtual
├── ortofoto_manager/              # Pacote principal
│   ├── __init__.py
│   ├── main.py
│   ├── scanner.py
│   ├── xref_repair.py
│   └── report_generator.py
│
├── output/                        # Saídas geradas
│   ├── ortofotos_catalogo.csv
│   ├── ortofotos_catalogo.json
│   ├── relatorio_analise.md
│   ├── chart_*.png
│   └── fix_ortofotos.{lsp,scr,bat}
│
├── logs/                          # Logs de execução
├── docs/                          # Documentação
├── tests/                         # Testes unitários
│
├── main.py                        # Ponto de entrada raiz
├── requirements.txt               # Dependências
├── README.md                      # Este arquivo
├── LICENSE                        # MIT License
└── .gitignore                     # Git ignore rules
```

---

## 🧪 Testes

### Executar Testes

```bash
pytest tests/ -v
```

### Cobertura de Testes

```bash
pytest tests/ --cov=ortofoto_manager --cov-report=html
```

---

## 🔍 Troubleshooting

### ❌ "ModuleNotFoundError: No module named 'ezdxf'"

**Solução**: Instale as dependências
```bash
pip install -r requirements.txt
```

### ❌ "Arquivo DWG não encontrado"

**Solução**: Verifique o caminho
```bash
python main.py --ortofotos-dir "C:\Caminho\Correto"
```

### ❌ Script .bat não abre AutoCAD

**Solução**: Verifique o caminho do AutoCAD em `fix_ortofotos.bat`
```batch
REM Edite a linha com o caminho correto do acad.exe
start "" "C:\Program Files\Autodesk\AutoCAD XXXX\acad.exe" ...
```

---

## 🛣️ Roadmap

### v1.1.0 (Q2 2026)
- [ ] Watchdog para monitoramento em tempo real
- [ ] Suporte a DXF nativo (ezdxf direto)
- [ ] Comparação entre versões de catálogos

### v2.0.0 (Q3 2026)
- [ ] Dashboard Streamlit interativo
- [ ] Integração Git para versionamento
- [ ] Pipeline CI/CD com GitHub Actions
- [ ] Suporte a múltiplos formatos de imagem

### v2.5.0 (Q4 2026)
- [ ] API REST (FastAPI)
- [ ] Banco de dados (SQLite/PostgreSQL)
- [ ] Interface gráfica (PyQt/Tkinter)

## 👤 Autor

**Fábio Luiz de Oliveira**

- 📧 Email: [fabioluol@hotmail.com](mailto:fabioluol@hotmail.com)
- 🔗 LinkedIn: [linkedin.com/in/fabio-luiz-de-oliveira](https://linkedin.com/in/fabio-luiz-de-oliveira)
- 🌐 Portfólio: [portfolio-analista-dados.vercel.app](https://portfolio-analista-dados-azure.vercel.app)

---

<div align="center">

**⭐ Se este projeto foi útil, considere dar uma estrela!**

[⬆ Voltar ao topo](#-ortofoto-manager--automação-inteligente-de-ortofotos-em-engenharia-civil)

</div>
