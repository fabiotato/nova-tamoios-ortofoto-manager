# Segurança e Políticas (Guardrails)

Este documento estabelece as diretrizes de segurança aplicáveis ao repositório **OrtoFoto Manager - Nova Tamoios**. Para garantir um ambiente seguro e limpo de informações sensíveis, siga rigorosamente os guardrails descritos abaixo.

## 🛡️ Guardrails Ativos

1. **Restrição de Arquivos Proprietários (CAD/DWG)**:
   - Todo fluxo de versionamento ignora nativamente os arquivos de projeto da Autodesk (e afins), particularmente o `.dwg`, `.dxf`, `.bak`. Isso está reforçado no `.gitignore` e impede o vazamento de projetos com propriedade intelectual da corporação/construtora.

2. **Gerenciamento de Segredos e Credenciais**:
   - É estritamente proibido *hardcodar* credenciais, URLs de banco de dados, senhas ou tokens diretos nos scripts.
   - Qualquer variável de ambiente deve ser carregada via `.env` (o qual está adicionado automaticamente no `.gitignore`).

3. **Arquivos Temporários e Scraps**:
   - Foram implementadas regras no projeto para ignorar pastas virtuais, builds, e caches Python (`.venv`, `__pycache__`) que podem expor detalhes do ambiente local do desenvolvedor.

## 🚨 Como relatar uma vulnerabilidade

A segurança é levada muito a sério neste projeto. Se você descobrir qualquer problema de segurança, dado sensível publicado, ou arquivo proprietário exposto, favor **NÃO** expor isso publicamente.

Ao invés disso:
- Abra uma [Issue Privada de Segurança](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing/privately-reporting-a-security-vulnerability) diretamente no GitHub caso disponível.
- Ou entre em contato com o administrador do repositório/analista de dados responsável (Fabio Luiz de Oliveira).

Uma resposta será fornecida o mais brevemente possível para a mitigação do risco.
