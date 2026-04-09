# 📊 Relatório de Análise — OrtoFoto Manager
## Recuperação de Referências de Ortofotos em Projetos AutoCAD

> **Projeto**: Mapa de Pendências — Panorama da Obra — Nova Tamoios / KYIOSHI
> **Data do Relatório**: 06/04/2026 04:53
> **Ferramenta**: OrtoFoto Manager v1.0.0
> **Contexto**: Solução automatizada para o problema de perda de referências de ortofotos
> quando arquivos DWG são abertos em máquinas diferentes.

---

## 1. Contexto do Problema

### O Que Acontece
Quando um arquivo DWG do AutoCAD contendo referências externas de imagens (ortofotos PNG)
é aberto em outro computador ou com um caminho de armazenamento diferente, **todos os
caminhos absolutos das imagens se quebram**. O AutoCAD exibe apenas o caminho antigo
ao invés da imagem propriamente dita.

### Impacto no Projeto Nova Tamoios
- **78 ortofotos** no total (Lote 1 + Lote 2)
- Todas no formato **PNG**
- Armazenadas em pasta "**Ortofotos Nova Tamoios**"
- Referência cruzada entre L1 e L2
- Processo manual de correção via comando `REDIR` do AutoCAD

### Solução Anterior (Manual)
O usuário precisava:
1. Copiar todas as 78 ortofotos para uma pasta única
2. Digitar `REDIR` no AutoCAD
3. Configurar as opções (XREFS + IMAGES)
4. Colar o novo caminho na linha de comando
5. Repetir para cada máquina/diferença de caminho

Este processo era **manual, propenso a erros e não reprodutível**.

### Nova Solução (Automatizada)
O **OrtoFoto Manager** automatiza todo o processo via Python:
- **Scanner automático** das 78 ortofotos com catálogo em DataFrame pandas
- **Script AutoLISP (.lsp)** que executa o REDIR automaticamente
- **Script de comando (.scr)** para correção em lote
- **Executável (.bat)** para rodar com um clique
- **Relatório de análise de dados** com gráficos e métricas

---

## 2. Catálogo de Ortofotos

### Resumo Geral
| Métrica | Valor |
|---------|-------|
| Total de ortofotos encontradas | 78 |
| Ortofotos esperadas | 78 |
| Completude | 100.0% |
| Lote 1 | 38 imagens |
| Lote 2 | 40 imagens |
| Tamanho total | 374.20 MB |

### Estatísticas Descritivas

| Estatística | Valor |
|-------------|-------|
| count | 78.00 MB |
| mean | 4.80 MB |
| std | 0.60 MB |
| min | 1.00 MB |
| 25% | 4.72 MB |
| 50% | 4.87 MB |
| 75% | 5.01 MB |
| max | 5.73 MB |

### Tabela Completa

| nome_arquivo   | lote   |   tamanho_mb |   largura_px |   altura_px | formato   | status     |
|:---------------|:-------|-------------:|-------------:|------------:|:----------|:-----------|
| L1-01.png      | L1     |         4.35 |         2289 |        2289 | .PNG      | encontrada |
| L1-02.png      | L1     |         4.84 |         2289 |        2289 | .PNG      | encontrada |
| L1-03.png      | L1     |         5.09 |         2289 |        2289 | .PNG      | encontrada |
| L1-04.png      | L1     |         4.99 |         2289 |        2289 | .PNG      | encontrada |
| L1-05.png      | L1     |         4.96 |         2289 |        2289 | .PNG      | encontrada |
| L1-06.png      | L1     |         4.92 |         2289 |        2289 | .PNG      | encontrada |
| L1-07.png      | L1     |         4.99 |         2289 |        2289 | .PNG      | encontrada |
| L1-08.png      | L1     |         4.94 |         2289 |        2289 | .PNG      | encontrada |
| L1-09.png      | L1     |         4.94 |         2289 |        2289 | .PNG      | encontrada |
| L1-10.png      | L1     |         5.10 |         2289 |        2289 | .PNG      | encontrada |
| L1-11.png      | L1     |         4.82 |         2289 |        2289 | .PNG      | encontrada |
| L1-12.png      | L1     |         5.08 |         2289 |        2289 | .PNG      | encontrada |
| L1-13.png      | L1     |         4.85 |         2289 |        2289 | .PNG      | encontrada |
| L1-14.png      | L1     |         4.80 |         2289 |        2289 | .PNG      | encontrada |
| L1-15.png      | L1     |         4.66 |         2289 |        2289 | .PNG      | encontrada |
| L1-16.png      | L1     |         4.68 |         2289 |        2289 | .PNG      | encontrada |
| L1-17.png      | L1     |         4.72 |         2289 |        2289 | .PNG      | encontrada |
| L1-18.png      | L1     |         4.72 |         2289 |        2289 | .PNG      | encontrada |
| L1-19.png      | L1     |         4.75 |         2289 |        2289 | .PNG      | encontrada |
| L1-20.png      | L1     |         4.93 |         2289 |        2289 | .PNG      | encontrada |

*... e mais 58 ortofotos (ver CSV completo)*

---

## 3. Análise de XREF / Referências Cruzadas

### Resultado da Reparação
| Status | Quantidade |
|--------|-----------|
| Total analisado | 0 |
| Corrigidos com sucesso | 0 |
| Arquivos não encontrados | 0 |
| Já OK (path existente) | 0 |
| Scripts gerados | 3 |


---

## 4. Relação com Análise de Dados

Esta solução aplica conceitos de ciência de dados de várias formas:

### 4.1. Engenharia de Dados — Catálogo Automatizado
O `OrtoFotoScanner` utiliza **pandas DataFrame** para catalogar as 78 ortofotos
com colunas estruturadas: nome, lote, tamanho, resolução, data, status.
Isso permite:
- **Filtragem**: `df[df['lote'] == 'L1']` — só ortofotos do Lote 1
- **Agregação**: `df.groupby('lote')['tamanho_mb'].sum()` — tamanho total por lote
- **Outlier detection**: boxplots identificam ortofotos com tamanho anormal
- **Data quality**: validação automática de completude (78 esperadas)

### 4.2. Análise Exploratória (EDA)
- **Histograma de tamanhos**: identifica a distribuição e possíveis arquivos corrompidos
- **Boxplot por lote**: compara a escala de ortofotos entre L1 e L2
- **Pie charts**: distribuição por formato e status de referência
- **Estatísticas descritivas**: média, mediana, desvio padrão dos tamanhos

### 4.3. Visualização de Dados
Gráficos matplotlib gerados automaticamente permitem:
- Comunicar status do projeto para stakeholders não-técnicos
- Documentar evidências de completude dos dados
- Criar dashboards visuais para acompanhamento de pendências

### 4.4. Automação de Processos
A conversão de um processo manual (REDIR) para scripts automatizados é
um exemplo clássico de **Data Engineering** — transformar tarefas repetitivas
em pipelines reprodutíveis, assim como fazemos com ETLs e data pipelines.

### 4.5. Qualidade de Dados
A verificação de "78 ortofotos esperadas" é análoga a:
- **Data validation** em pipelines de dados
- **Schema checking** em tabelas de banco de dados
- **Reconciliation** entre sistemas (esperado vs. encontrado)

---

## 5. Gráficos Gerados

### Distribuicao Lotes

![distribuicao_lotes](output/chart_distribuicao_lotes.png)

### Analise Tamanhos

![analise_tamanhos](output/chart_analise_tamanhos.png)

### Status Referencias

![status_referencias](output/chart_status_referencias.png)

### Distribuicao Formatos

![distribuicao_formatos](output/chart_formatos.png)

---

## 6. Arquivos de Saída

### Scripts de Correção AutoCAD
| Arquivo | Tipo | Descrição |
|---------|------|-----------|
| `fix_ortofotos.lsp` | AutoLISP | Carregável no AutoCAD — digite FIX_ORTOFOTOS |
| `fix_ortofotos.scr` | Script | Executável via accoreconsole ou arrastar para o CAD |
| `fix_ortofotos.bat` | Batch | Executável com duplo-clique (requer AutoCAD instalado) |

### Relatórios e Análises
| Arquivo | Tipo | Descrição |
|---------|------|-----------|
| `output/ortofotos_catalogo.csv` | CSV | Catálogo completo de todas as ortofotos |
| `output/ortofotos_catalogo.json` | JSON | Catálogo para consumo via API/Python |
| `output/relatorio_analise.md` | Markdown | Este relatório |
| `output/chart_*.png` | PNG | Gráficos de análise |

### Código Fonte
| Módulo | Responsabilidade |
|--------|-----------------|
| `ortofoto_manager/scanner.py` | Scanner e catálogo de ortofotos |
| `ortofoto_manager/xref_repair.py` | Correção de paths XREF + scripts |
| `ortofoto_manager/report_generator.py` | Relatório e gráficos |
| `ortofoto_manager/__init__.py` | Pacote e versionamento |

---

## 7. Como Usar

### Opção 1: Via Linha de Comando Python
```bash
.venv\Scripts\activate
python main.py
```

### Opção 2: Scripts AutoCAD (sem Python)
1. Execute `fix_ortofotos.bat` (duplo clique)
2. O AutoCAD abrirá e corrigirá automaticamente os caminhos
3. Verifique no modelo — todas as ortofotos devem aparecer

### Opção 3: Processo Manual (fallback)
1. No AutoCAD, digite `REDIR`
2. Pressione ENTER → marque XREFS + IMAGES → OK
3. Digite `*` e ENTER
4. Cole o novo caminho da pasta de ortofotos
5. ENTER para finalizar

---

## 8. Fluxo de Entrega (CD/DVD)

Conforme o PDF original, o processo correto de gravação:

1. **PUBLISH > eTransmit** no AutoCAD
2. Salva o arquivo ZIP gerado
3. **EXTRAI** o ZIP para uma pasta (não grave comprimido!)
4. Verifique se todas as ortofotos aparecem no DWG
5. Grave a "pasta-mãe" completa no CD/DVD
6. **Nunca** leve só o DWG — leve toda a estrutura de pastas

---

## 9. Conclusão

O **OrtoFoto Manager** transforma um processo manual e propenso a erros em uma
solução **automatizada, reproduzível e documentável**. Combinando análise de
dados (pandas + matplotlib) com automação CAD (ezdxf + scripts AutoLISP),
a ferramenta oferece:

- **Eficiência**: correção em segundos ao invés de minutos manuais
- **Confiabilidade**: validação automática de completude (78 ortofotos)
- **Auditabilidade**: relatórios e logs para acompanhamento
- **Escalabilidade**: adaptável para outros projetos com ortofotos
- **Análise de Dados**: catálogo, métricas e visualizações para gestão

---

*Relatório gerado automaticamente pelo OrtoFoto Manager v1.0.0*
*{datetime.now().strftime("%d/%m/%Y às %H:%M:%S")}*
