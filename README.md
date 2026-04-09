# 📊 OrtoFoto Manager v1.0.0

**Automação Inteligente de Correção de Referências de Ortofotos em Projetos AutoCAD**

> *Ferramenta de Análise de Dados + Automação CAD para o Projeto Nova Tamoios — Mapa de Pendências (KYIOSHI)*

---

## 📋 Índice

1. [Contexto do Problema](#1-contexto-do-problema)
2. [Impacto no Projeto](#2-impacto-no-projeto)
3. [Solução Anterior vs. Nova Solução](#3-solução-anterior-vs-nova-solução)
4. [Arquitetura da Solução](#4-arquitetura-da-solução)
5. [Instalação e Ambiente](#5-instalação-e-ambiente)
6. [Como Usar](#6-como-usar)
7. [Módulos do Código](#7-módulos-do-código)
8. [Relação com Análise de Dados](#8-relação-com-análise-de-dados)
9. [Scripts AutoCAD Gerados](#9-scripts-autocad-gerados)
10. [Fluxo de Entrega em CD/DVD](#10-fluxo-de-entrega-em-cddvd)
11. [Estrutura de Arquivos](#11-estrutura-de-arquivos)
12. [Saídas Geradas](#12-saídas-geradas)
13. [Extensões Futuras](#13-extensões-futuras)

---

## 1. Contexto do Problema

### 1.1 O Que Acontece

Arquivos AutoCAD (`.DWG`) que contêm **referências externas de imagens** (ortofotos no formato PNG) armazenam **caminhos absolutos** para essas imagens. Exemplo:

```
C:\Usuarios\Fabio\Projetos\Novas\Ortofotos Nova Tamoios\L1_ORTOFOTO_001.png
```

Quando o arquivo DWG é:
- Copiado para **outro computador**
- Aberto a partir de um **servidor diferente**
- Transferido para **HD externo**, **CD** ou **DVD**

...o caminho absoluto **não existe mais** na máquina destino. O AutoCAD exibe apenas o caminho antigo ao invés da imagem — a referência é "perdida".

### 1.2 Complexidade Adicional

No Projeto Nova Tamoios o problema é amplificado por:
- **78 ortofotos** no total (distribuídas entre Lote 1 e Lote 2)
- Imagens de alta resolução (PNG, dezenas a centenas de MB cada)
- Necessidade de entregar o projeto em mídia física (CD/DVD)
- Múltiplas pessoas acessando o arquivo em máquinas diferentes

---

## 2. Impacto no Projeto

| Aspecto | Detalhe |
|---------|---------|
| **Ortofotos totais** | 78 (formato PNG) |
| **Lotes** | L1 (Lote 1) + L2 (Lote 2) |
| **Tipo de referência** | XREF / IMAGEDEF (referência externa raster) |
| **Formato CAD** | DWG (AutoCAD) |
| **Arquivo principal** | `Mapa de Pendencias - Panorama da Obra - Kyioshi FINAL.dwg` |
| **Pasta de ortofotos** | `Ortofotos Nova Tamoios` |
| **Frequência do problema** | Toda vez que o DWG é movido de local/máquina |

---

## 3. Solução Anterior vs. Nova Solução

### 3.1 Processo Manual (Anterior — via REDIR)

O processo manual que exigia:

1. Copiar todas as 78 ortofotos para uma pasta única
2. Digitar `REDIR` na linha de comando do AutoCAD
3. Configurar: XREFS ✅ + IMAGES ✅ → OK
4. Digitar `*` para todos os arquivos
5. Copiar o caminho novo do Windows Explorer
6. Colar na linha de comando do AutoCAD
7. Torcer para funcionar (sem validação de completude)

**Problemas**: manual, não reprodutível, sem registro, sem validação, propenso a erro humano.

### 3.2 Solução Automatizada (OrtoFoto Manager)

```
┌─────────────────────────────────────────────────┐
│           OrtoFoto Manager — Pipeline            │
├─────────────────────────────────────────────────┤
│                                                 │
│  1. Scan → 2. Análise → 3. Correção → 4. Report │
│     │            │             │            │    │
│     ▼            ▼             ▼            ▼    │
│  Catálogo    DataFrame    Scripts .lsp   Markdown │
│  CSV/JSON    + Gráficos   Scripts .scr   + PNGs   │
│                          Scripts .bat              │
└─────────────────────────────────────────────────┘
```

A nova solução oferece:
- **Scan automático**: descobre todas as 78 ortofotos sem intervenção manual
- **Catálogo em DataFrame**: pandas organiza nome, lote, tamanho, resolução, data, status
- **Validação de completude**: verifica se as 78 esperadas foram encontradas
- **Scripts autoexecutáveis**: `.lsp`, `.scr`, `.bat` — correção com um clique
- **Relatório completo**: Markdown + gráficos de análise de dados
- **Reprodutibilidade**: mesmo resultado toda vez, sem variação humana

---

## 4. Arquitetura da Solução

### 4.1 Diagrama de Componentes

```
main.py (Ponto de Entrada)
    │
    ├──► ortofoto_manager/scanner.py
    │       │   OrtoFotoScanner
    │       ├── discover_ortofotos()     → lista de dict
    │       ├── scan()                   → pandas DataFrame
    │       ├── export_csv()             → output/catalogo.csv
    │       └── export_json()            → output/catalogo.json
    │
    ├──► ortofoto_manager/xref_repair.py
    │       │   XREFRepair
    │       ├── analyze_dxfref()         → diagnóstico de paths
    │       ├── fix_paths_in_dxf()       → corrige paths (via ezdxf)
    │       └── generate_autocad_script()→ .lsp + .scr + .bat
    │
    └──► ortofoto_manager/report_generator.py
            │   ReportGenerator
            ├── generate_charts()        → gráficos matplotlib PNG
            ├── generate_markdown_report()→ relatório completo
            └── save_report()            → output/relatorio.md
```

### 4.2 Tecnologias Utilizadas

| Tecnologia | Versão | Papel |
|-----------|--------|-------|
| **Python** | 3.14+ | Linguagem principal |
| **ezdxf** | 1.4+ | Leitura/escrita de arquivos DXF |
| **pandas** | 3.0+ | Catálogo, EDA, dataframes |
| **matplotlib** | 3.10+ | Gráficos e visualizações |
| **Pillow** | 12.2+ | Metadados de imagem (resolução) |
| **rich** | 14.3+ | Interface de terminal (tabelas, barras) |
| **tabulate** | 0.10+ | Tabelas em relatórios Markdown |
| **colorama** | 0.4+ | Cores no terminal (Windows) |

---

## 5. Instalação e Ambiente

### 5.1 Ambiente Virtual (VENV) — Já Configurado

O projeto já possui ambiente virtual criado e configurado:

```bash
# Ativar o ambiente virtual
.venv\Scripts\activate

# Verificar que está ativo (deve mostrar .venv no path)
where python
```

### 5.2 Instalação Manual (se necessário)

```bash
# Criar venv do zero
python -m venv .venv

# Ativar
.venv\Scripts\activate

# Instalar dependências
pip install -r requirements.txt
```

### 5.3 Verificação

```bash
.venv\Scripts\activate
python -c "import ezdxf, pandas, matplotlib, rich; print('Tudo OK!')"
```

---

## 6. Como Usar

### 6.1 Execução Completa (recomendado)

```bash
.venv\Scripts\activate
python main.py
```

Executa todas as etapas: scan → análise → scripts → relatório.

### 6.2 Apenas Scan

```bash
python main.py --scan-only
```

Apenas descobre e cataloga as ortofotos (gera CSV + JSON).

### 6.3 Apenas Scripts AutoCAD

```bash
python main.py --scripts-only
```

Gera `.lsp`, `.scr` e `.bat` sem re-escanear.

### 6.4 Apenas Relatório

```bash
python main.py --report-only
```

Gera relatório Markdown e gráficos sem reprocessar.

### 6.5 Caminho Personalizado

```bash
python main.py --ortofotos-dir "D:\MinhaPasta\Ortofotos"
```

### 6.6 Modo Sem Python (apenas AutoCAD)

Se não tiver Python instalado na máquina destino:

1. Copie os scripts gerados (`.lsp`, `.scr`, `.bat`) junto com o DWG
2. Execute `fix_ortofotos.bat` — duplo clique
3. O AutoCAD abrirá, executará o REDIR automaticamente e salvará

---

## 7. Módulos do Código

### 7.1 `scanner.py` — Scanner de Ortofotos

**Responsabilidade**: Descobrir, catalogar e analisar todas as ortofotos do projeto.

```python
scanner = OrtoFotoScanner(project_dir=".", ortofotos_folder="Ortofotos Nova Tamoios")
df = scanner.scan()
print(scanner.summary())
scanner.export_csv("output/catalogo.csv")
```

**Métodos principais**:

| Método | Retorna | Descrição |
|--------|---------|-----------|
| `discover_ortofotos()` | `list[dict]` | Lista de metadados de cada imagem |
| `scan()` | `pd.DataFrame` | DataFrame completo com colunas analisáveis |
| `summary()` | `str` | Resumo textual formatado |
| `export_csv()` | `str` | Salva CSV exportável |
| `export_json()` | `str` | Salva JSON para API |

**Colunas do DataFrame**:
- `nome_arquivo` — nome do arquivo
- `lote` — L1 ou L2 (classificação automática pelo nome)
- `tamanho_bytes` / `tamanho_mb` — tamanho do arquivo
- `largura_px` / `altura_px` — resolução da imagem
- `resolucao_total_px` — largura × altura
- `formato` — extensão (.PNG, .JPG, etc.)
- `data_criacao` / `data_modificacao` — timestamps
- `status` — found, erro, not_found
- `tamanho_categoria` — binning automático (<5MB, 5-20MB, etc.)

### 7.2 `xref_repair.py` — Correção de Paths XREF

**Responsabilidade**: Automatizar o processo REDIR do AutoCAD.

```python
xref = XREFRepair(project_dir=".")

# Opção A: Correção direta em DXF (precisa conversor DWG→DXF)
resultado = xref.fix_paths_in_dxf("mapa.dxf", "novo/caminho/ortofotos/")

# Opção B: Gerar scripts para o AutoCAD (recomendado, sem dependência externa)
scripts = xref.generate_autocad_script("c:/ortofotos/novo/caminho")
```

**O que gera**:

| Arquivo | Formato | Como executar |
|---------|---------|---------------|
| `fix_ortofotos.lsp` | AutoLISP | Drag-and-drop no AutoCAD |
| `fix_ortofotos.scr` | Script CAD | Arrastar para o CAD ou accoreconsole |
| `fix_ortofotos.bat` | Batch Windows | Duplo clique (abre CAD automaticamente) |

### 7.3 `report_generator.py` — Relatórios e Gráficos

**Responsabilidade**: Gerar relatório Markdown e gráficos de análise.

```python
reporter = ReportGenerator(project_dir=".", scanner_df=df)
charts = reporter.generate_charts()
reporter.save_report(xref_results=xref_resultados)
```

**Gráficos gerados**:

| Gráfico | Tipo | O Que Mostra |
|---------|------|--------------|
| `chart_distribuicao_lotes.png` | Barras | Quantidade L1 vs L2 |
| `chart_analise_tamanhos.png` | Histograma + Boxplot | Distribuição de tamanhos |
| `chart_status_referencias.png` | Pizza | Status (OK / Broken) |
| `chart_formatos.png` | Pizza | Distribuição por formato |

---

## 8. Relação com Análise de Dados

Esta solução é um exemplo prático de como conceitos de **Ciência de Dados** se aplicam a problemas de **Engenharia Civil / CAD**:

### 8.1 Engenharia de Dados (Data Engineering)

O `OrtoFotoScanner` constrói um **catálogo estruturado** das 78 ortofotos usando pandas DataFrame — equivalente a um schema de banco de dados:

```python
# Filtro — como WHERE em SQL
df_l1 = df[df['lote'] == 'L1']

# Agregação — como GROUP BY
df.groupby('lote')['tamanho_mb'].agg(['sum', 'mean', 'count'])

# Ordenação — como ORDER BY
df.sort_values('tamanho_mb', ascending=False)
```

### 8.2 Análise Exploratória de Dados (EDA)

- **Histograma de tamanhos**: detecta outliers (ortofotos corrompidas ou desnecessariamente grandes)
- **Boxplot por lote**: compara escala entre Lote 1 e Lote 2
- **Estatísticas descritivas**: média, mediana, desvio padrão revelam padrões
- **Valoração de completude**: `total_encontrado / 78 * 100` — métrica KPI

### 8.3 Visualização de Dados

Os gráficos matplotlib servem como **artefatos de comunicação**:
- Para **gestores**: mostram completude do projeto de forma visual
- Para **equipe técnica**: identificam anomalias (imagens fora do padrão)
- Para **clientes**: evidência de qualidade e controle

### 8.4 Qualidade de Dados (Data Quality)

A validação automática implementada é análoga a práticas de Data Engineering:

| Conceito de DQ | Implementação no OrtoFoto Manager |
|----------------|-----------------------------------|
| **Completude** | Verifica 78/78 ortofotos presentes |
| **Consistência** | Classificação automática por lote |
| **Validação** | Check se arquivos existem (status) |
| **Monitoramento** | Catálogo CSV/JSON reutilizável |

### 8.5 Automação de Processos

O mapeamento de um processo manual (REDIR) para um pipeline automatizado é o cerne da **automação de dados**:
- **ANTES**: processo manual → variável → sem registro → não reprodutível
- **DEPOIS**: pipeline Python → consistente → com logs → 100% reprodutível

---

## 9. Scripts AutoCAD Gerados

### 9.1 Script AutoLISP (`fix_ortofotos.lsp`)

Quando carregado no AutoCAD, cria o comando `FIX_ORTOFOTOS` que:
1. Itera sobre todos os `IMAGEDEF` no banco de dados do desenho
2. Para cada imagem com caminho quebrado, busca no novo diretório
3. Se encontrar: substitui o path
4. Se não encontrar: loga o arquivo ausente
5. Exibe resumo final

**Como usar**:
```
1. Abra o DWG no AutoCAD
2. Arraste o arquivo .lsp para a janela do AutoCAD
3. Digite: FIX_ORTOFOTOS
4. Pressione Enter — pronto!
```

### 9.2 Script de Comando (`fix_ortofotos.scr`)

Script que simula a digitação manual dos comandos REDIR:
```
REDIR
*
XREFS
IMAGES
*
CAMINHO_NOVO_DAS_ORTOFOTOS
_zoom
_extents
_qsave
```

**Como usar**:
```
1. Abra o DWG no AutoCAD
2. Digite SCRIPT na linha de comando
3. Selecione o arquivo fix_ortofotos.scr
4. Aguarde a execução
```

### 9.3 Executável Batch (`fix_ortofotos.bat`)

Wrapper que abre o AutoCAD com o DWG e executa o script automaticamente.

**Como usar**:
```
1. Duplo clique no .bat
2. O AutoCAD abre, executa a correção e salva
3. Verifique o resultado
```

---

## 10. Fluxo de Entrega em CD/DVD

Conforme documentado no PDF original, o processo **CORRETO** de gravação:

### ✅ Procedimento Correto

1. No AutoCAD: **PUBLISH → eTransmit**
2. ConfirmeSalvar quando solicitado
3. Salva o arquivo **ZIP** gerado
4. **EXTRAI** o ZIP para uma pasta normal
5. Abra o DWG da pasta extraída e verifique ortofotos
6. Grave a **"pasta-mãe" completa** no CD/DVD
7. Sempre transporte toda a estrutura de pastas

### ❌ Erro Comum

Gravar o ZIP direto no CD/DVD — o destinatário esquece de extrair e as ortofotos não aparecem.

### Como o OrtoFoto Manager Ajuda

O catálogo CSV/JSON gerado serve como **checklist de recebimento**:
```python
import pandas as pd
catalogo = pd.read_csv("ortofotos_catalogo.csv")
print(f"Ortofotos recebidas: {len(catalogo)} de 78")
```

---

## 11. Estrutura de Arquivos

```
Mapa de Pendencias - Panorama da Obra - Kyioshi FINAL - Standard/
│
├── .venv/                          # Ambiente virtual Python
│   └── Scripts/
│       ├── activate.bat
│       └── python.exe
│
├── ortofoto_manager/               # Pacote principal
│   ├── __init__.py                 # Init do pacote
│   ├── main.py                     # Ponto de entrada CLI
│   ├── scanner.py                  # Scanner de ortofotos
│   ├── xref_repair.py              # Reparo de paths XREF
│   └── report_generator.py         # Relatórios e gráficos
│
├── main.py                         # Ponto de entrada raiz
├── requirements.txt                # Dependências
│
├── docs/
│   └── config.json                 # Configuração do projeto
│
├── output/                         # Saídas geradas
│   ├── ortofotos_catalogo.csv      # Catálogo completo
│   ├── ortofotos_catalogo.json     # Catálogo JSON
│   ├── relatorio_analise.md        # Relatório completo
│   ├── chart_distribuicao_lotes.png
│   ├── chart_analise_tamanhos.png
│   ├── chart_status_referencias.png
│   └── chart_formatos.png
│
├── fix_ortofotos.lsp               # Script AutoLISP (gerado)
├── fix_ortofotos.scr               # Script de comando (gerado)
├── fix_ortofotos.bat               # Executável batch (gerado)
│
├── logs/                           # Logs de execução
│
├── README.md                       # Este arquivo
│
└── [arquivos do projeto original]
    ├── Mapa de Pendencias - Panorama da Obra - Kyioshi FINAL.dwg
    └── Recuperando ortofotos no Mapa e Salvamento adequado em CD ou DVD.pdf
```

---

## 12. Saídas Geradas

### 12.1 Catálogo de Dados

| Saída | Formato | Uso |
|-------|---------|-----|
| `output/ortofotos_catalogo.csv` | CSV | Abre no Excel para análise manual |
| `output/ortofotos_catalogo.json` | JSON | Consumo via API ou outros scripts Python |
| `output/relatorio_analise.md` | Markdown | Documentação completa legível |

### 12.2 Visualizações

| Gráfico | Arquivo | Insight |
|---------|---------|---------|
| Distribuição por Lote | `chart_distribuicao_lotes.png` | Equilíbrio L1 vs L2 |
| Análise de Tamanhos | `chart_analise_tamanhos.png` | Outliers, média, mediana |
| Status de Referências | `chart_status_referencias.png` | Saúde dos paths de imagem |
| Distribuição de Formatos | `chart_formatos.png` | Padrão de arquivos |

### 12.3 Scripts de Correção

| Script | Extensão | Sem Python? |
|--------|----------|-------------|
| AutoLISP | `.lsp` | ✅ |
| Script CAD | `.scr` | ✅ |
| Batch | `.bat` | ✅ |

---

## 13. Extensões Futuras

| Feature | Descrição | Prioridade |
|---------|-----------|------------|
| **Watchdog** | Monitora pasta de ortofotos e alerta ao adicionar/remover | Alta |
| **Dashboard Streamlit** | Interface web interativa para análise | Média |
| **Integração Git** | Versiona catálogo e detecta mudanças | Baixa |
| **Suporte DXF nativo** | Correção direta em arquivos DXF via ezdxf | Média |
| **Comparação entre versões** | Diff de catálogos entre entregas | Baixa |
| **Pipeline CI/CD** | Validação automática em commit | Baixa |

---

## Créditos

- **Problema identificado**: PDF "Recuperando ortofotos no Mapa e Salvamento adequado em CD ou DVD.pdf"
- **Projeto**: Mapa de Pendências — Nova Tamoios / KYIOSHI
- **Solução**: OrtoFoto Manager v1.0.0
- **Arquitetura**: Python + pandas + matplotlib + ezdxf + scripts AutoCAD
- **Data**: 06/04/2026


