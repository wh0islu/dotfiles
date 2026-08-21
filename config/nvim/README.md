# Minha Configuracao Neovim

Esta configuracao fica em `~/.config/nvim` e usa Lua com carregamento modular.
O arquivo de entrada e `init.lua`, que carrega opcoes gerais, atalhos, runner,
plugins e o tema local `cyberia`.

## Estrutura

```text
init.lua
lazy-lock.json
lua/
  core/
    dashboard.lua
    commands.lua
    diagnostics.lua
    sets.lua
    map.lua
    run.lua
    plugins.lua
  plugins/
    bufferline.lua
    cmp.lua
    colorizer.lua
    comment.lua
    lualine.lua
    markdown.lua
    mason.lua
    ntree.lua
    nvim_dap.lua
    persistence.lua
    fugitive.lua
    telescope.lua
    which_key.lua
    gitsigns.lua
    todo_comments.lua
    toggleterm.lua
  themes/
    cyberia.lua
    kaizen.lua
```

## Base

O Neovim usa `lazy.nvim` como gerenciador de plugins. Caso o Lazy nao exista em
`~/.local/share/nvim/lazy/lazy.nvim`, ele e clonado automaticamente.

Os plugins sao carregados sob demanda quando possivel. Telescope, NvimTree,
ToggleTerm, completion, LSP, DAP, Git helpers e outras ferramentas entram apenas
quando um comando, tecla ou evento precisa deles. Isso mantem o startup mais
leve.

Quando o Neovim abre sem arquivo, `lua/core/dashboard.lua` cria uma tela inicial
minimalista com logo central em ASCII e um menu de acoes rapidas.

As opcoes principais ficam em `lua/core/sets.lua`:

- encoding em UTF-8
- numeracao de linhas ativa
- cursorline ativa
- clipboard integrado com o sistema via `unnamedplus`
- `termguicolors` ativo
- tabline sempre visivel
- indentacao configurada com largura 4
- `cmdheight = 0` para uma linha de comando mais compacta

## Atalhos

O leader esta definido como `,`.

| Atalho | Acao |
| --- | --- |
| `<C-r>` | executa a funcao `Run()` para o arquivo atual |
| `<C-s>` | salva com `:w!` |
| `<C-q>` | fecha a janela atual com `:q` |
| `<C-x>` | salva e fecha com `:x` |
| `g` | vai para o inicio do arquivo com `gg` |
| `<C-n>` | abre/fecha o NvimTree |
| `<C-t>` | abre/fecha o ToggleTerm |
| `<leader>ai` | abre/fecha o Codex em terminal lateral |
| `<C-f>` | abre o Telescope |
| `<leader>f` | abre o grupo Find no which-key |
| `<leader>ff` | busca arquivos com Telescope |
| `<leader>fg` | busca texto no projeto com Telescope |
| `<leader>fb` | lista buffers abertos |
| `<leader>fo` | lista arquivos recentes |
| `<leader>fd` | lista diagnostics |
| `<leader>fs` | lista symbols do arquivo atual |
| `<leader>fS` | lista symbols do workspace |
| `<leader>gt` | abre lazygit |
| `<leader>gg` | abre Git status com Fugitive |
| `<leader>gc` | abre Git commit |
| `<leader>gP` | executa Git push |
| `<leader>gl` | executa Git pull |
| `<leader>gs` | stage do hunk atual |
| `<leader>gr` | reset do hunk atual |
| `<leader>gp` | preview do hunk atual |
| `<leader>gb` | blame da linha atual |
| `[d` | diagnostic anterior |
| `]d` | proximo diagnostic |
| `<leader>ld` | lista diagnostics no quickfix |
| `<leader>qs` | restaura sessao do projeto |
| `<leader>ql` | restaura ultima sessao |
| `<leader>qd` | desativa salvamento da sessao atual |
| `<leader>ac` | abre Codex no projeto atual |
| `<leader>ar` | reinicia Codex |
| `<leader>ak` | fecha Codex |
| `<leader>td` | busca TODO/FIXME/NOTE com Telescope |
| `<leader>tr` | roda `python manage.py runserver` |
| `<leader>tn` | roda `npm run dev` |
| `<leader>ts` | cria projeto Spring Boot padronizado |
| `<leader>tg` | abre lazygit |
| `<C-w>` no terminal | sai do modo terminal e troca de janela |
| `<C-w>` no modo normal | troca de janela |
| `<Tab>` | proximo buffer no Bufferline |
| `<S-Tab>` | buffer anterior no Bufferline |
| `K` | hover do LSP |
| `gd` | ir para definicao pelo LSP |
| `<leader>ca` | code action do LSP |
| `p` na tela inicial | lista repositorios em `~/Developments/Git` |
| `f` na tela inicial | busca arquivos no projeto atual |
| `g` na tela inicial | busca texto no projeto atual |
| `s` na tela inicial | lista arquivos recentes com Telescope |
| `c` na tela inicial | abre `~/.config/nvim/init.lua` |
| `L` na tela inicial | abre o Lazy |
| `q` na tela inicial | sai do Neovim |

## Runner

O arquivo `lua/core/run.lua` cria o comando `:Run` e tambem e chamado por
`<C-r>`.

O runner tenta detectar primeiro o tipo de projeto:

| Arquivo do projeto | Comando |
| --- | --- |
| `manage.py` + `pyproject.toml` | `poetry run python manage.py runserver` |
| `manage.py` | `python manage.py runserver` |
| `package.json` | `npm run dev` |
| `mvnw` + `pom.xml` | `./mvnw spring-boot:run` |
| `gradlew` + `build.gradle` | `./gradlew bootRun` |
| `pom.xml` | `mvn spring-boot:run` |
| `build.gradle` | `gradle bootRun` |
| `Cargo.toml` | `cargo run` |
| `go.mod` | `go run .` |

Para comandos Java/Spring Boot, o runner usa `JAVA_HOME=/usr/lib/jvm/java-21-openjdk`
quando esse JDK estiver instalado. Isso evita erro de Maven como
`release version 21 not supported` quando o Java default do sistema ainda for 17.

Em projetos Maven Spring Boot, o runner tambem procura a classe com
`@SpringBootApplication` em `src/main/java` e passa explicitamente
`-Dspring-boot.run.main-class=...`. Isso evita falhas do plugin Maven ao tentar
inferir a classe principal.

Se nao encontrar um projeto conhecido, ele roda pelo tipo do arquivo atual:

| Extensao | Comando |
| --- | --- |
| `.py` | `python3 arquivo.py` ou `poetry run python arquivo.py` |
| `.c` | `gcc arquivo.c -o output && ./output` |
| `.rs` | `rustc arquivo.rs -o output && ./output` |
| `.go` | `go run arquivo.go` |
| `.js` | `node arquivo.js` |
| `.ts` | `npx ts-node arquivo.ts` |
| `.java` | `java arquivo.java` |

Antes de executar, o arquivo atual e salvo automaticamente e o comando roda em
um terminal horizontal do ToggleTerm.

## Spring Boot

Criar um projeto Spring Boot padronizado:

```vim
:NewSpringBoot
```

Atalho:

```text
,ts
```

O comando cria o projeto em `~/Developments/Git` usando Spring Initializr.
Por padrao, as dependencias sao:

```text
web,validation,lombok,devtools
```

Banco de dados nao vem ativo por padrao para evitar erro inicial de DataSource.
Se responder `y` em `Include JPA/PostgreSQL?`, o comando tambem inclui:

```text
data-jpa,postgresql
```

O comando tambem cria um `HomeController` inicial com `GET /`, retornando
`Spring Boot OK`. Isso evita a pagina Whitelabel 404 ao abrir
`http://localhost:8080` logo depois de subir o projeto.

## Plugins

Plugins declarados em `lua/core/plugins.lua`:

- `nvim-lualine/lualine.nvim`: statusline
- `akinsho/bufferline.nvim`: abas/buffers no topo
- `NvChad/nvim-colorizer.lua`: preview de cores em CSS, RGB, HSL e hex
- `numToStr/Comment.nvim`: comentarios por atalho padrao do plugin
- `folke/which-key.nvim`: menu visual de atalhos com leader
- `lewis6991/gitsigns.nvim`: sinais e acoes Git por hunk
- `folke/todo-comments.nvim`: destaque e busca de TODO/FIXME/NOTE
- `folke/persistence.nvim`: sessoes por projeto
- `nvim-telescope/telescope.nvim`: busca e seletores
- `nvim-telescope/telescope-ui-select.nvim`: UI select usando Telescope
- `nvim-tree/nvim-tree.lua`: explorador de arquivos
- `akinsho/toggleterm.nvim`: terminal integrado
- `tpope/vim-fugitive`: integracao Git
- `williamboman/mason.nvim`: instalador de ferramentas LSP
- `williamboman/mason-lspconfig.nvim`: integracao Mason + LSP
- `WhoIsSethDaniel/mason-tool-installer.nvim`: instala ferramentas extras do Mason
- `neovim/nvim-lspconfig`: configuracao de servidores LSP
- `mfussenegger/nvim-jdtls`: Java LSP, testes e debug via Eclipse JDT LS
- `hrsh7th/nvim-cmp`: autocomplete
- `L3MON4D3/LuaSnip`: snippets
- `saadparwaiz1/cmp_luasnip`: fonte LuaSnip para completion
- `rafamadriz/friendly-snippets`: snippets prontos
- `nvim-treesitter/nvim-treesitter`: highlight por parser para Lua, Python, JS, TS e C
- `mfussenegger/nvim-dap`: debug adapter protocol
- `nvim-neotest/nvim-nio`: dependencia do DAP UI
- `rcarriga/nvim-dap-ui`: interface visual para debug

## LSP

O LSP e configurado em `lua/plugins/mason.lua`.

Servidores garantidos pelo Mason:

- `pyright`
- `clangd`
- `lua_ls`
- `ts_ls`

O `lua_ls` conhece `vim` como global, usa a pasta `lua` da propria configuracao
como biblioteca e desativa telemetria.

Java usa `nvim-jdtls` em vez do handler generico do `lspconfig`. Ao abrir um
arquivo `.java`, ele procura um projeto Maven/Gradle por `pom.xml`, `mvnw`,
`build.gradle`, `gradlew` ou `.git`, cria um workspace em
`~/.local/share/nvim/jdtls-workspace/` e usa as ferramentas instaladas pelo
Mason:

- `jdtls`
- `java-debug-adapter`
- `java-test`

O `jdtls` usa `/usr/lib/jvm/java-21-openjdk/bin/java` quando esse Java estiver
instalado. Isso permite manter outro Java como default do sistema e ainda assim
rodar o language server moderno.

Atalhos Java:

| Atalho | Acao |
| --- | --- |
| `<leader>jo` | organiza imports |
| `<leader>jt` | roda testes da classe |
| `<leader>jn` | roda teste do metodo atual |
| `<leader>jv` | extrai variavel no modo visual |
| `<leader>jc` | extrai constante no modo visual |
| `<leader>jm` | extrai metodo no modo visual |

Atalhos extras quando um LSP anexa ao buffer:

| Atalho | Acao |
| --- | --- |
| `gD` | declaracao |
| `gd` | definicao |
| `K` | hover |
| `gi` | implementacao |
| `<space>wa` | adiciona workspace folder |
| `<space>wr` | remove workspace folder |
| `<space>wl` | lista workspace folders |
| `<space>D` | type definition |
| `<space>rn` | rename |
| `<space>ca` | code action |
| `gr` | referencias |
| `<space>f` | formatacao async |

## Autocomplete

O autocomplete fica em `lua/plugins/cmp.lua`.

Fontes ativas:

- LSP via `nvim_lsp`
- snippets via `luasnip`
- buffer atual

Atalhos no menu de completion:

| Atalho | Acao |
| --- | --- |
| `<C-b>` | rola documentacao para cima |
| `<C-f>` | rola documentacao para baixo |
| `<C-o>` | abre o completion |
| `<C-e>` | fecha/cancela |
| `<CR>` | confirma item selecionado |

## Debug

O debug fica em `lua/plugins/nvim_dap.lua`.

Python usa:

```text
~/.venv/bin/python3
```

Esse Python precisa ter `debugpy` instalado para o adapter funcionar.

Atalhos:

| Atalho | Acao |
| --- | --- |
| `<F5>` | continue |
| `<F10>` | step over |
| `<F11>` | step into |
| `<F12>` | step out |
| `<leader>b` | alterna breakpoint |
| `<leader>B` | breakpoint condicional |

O `nvim-dap-ui` abre automaticamente ao iniciar uma sessao de debug e fecha ao
terminar ou sair.

## Interface

### NvimTree

Configurado em `lua/plugins/ntree.lua`:

- largura de 30 colunas
- lado esquerdo
- sem signcolumn
- atualiza o arquivo focado
- atualiza o cwd conforme o arquivo focado
- nao usa window picker ao abrir arquivo
- nao hijacka diretorios

### Telescope

Configurado em `lua/plugins/telescope.lua` com `ui-select` em modo dropdown.

No dashboard, a tecla `p` usa Telescope para listar repositorios encontrados em
`~/Developments/Git`. Ao selecionar um projeto, o Neovim muda o diretorio de
trabalho para o repositorio escolhido e abre o NvimTree.

Atalhos principais:

- `<leader>ff`: busca arquivos
- `<leader>fg`: busca texto no projeto
- `<leader>fb`: lista buffers
- `<leader>fo`: lista arquivos recentes
- `<leader>fd`: lista diagnostics
- `<leader>fs`: lista symbols do arquivo atual
- `<leader>fS`: lista symbols do workspace

### Which-key

Configurado em `lua/plugins/which_key.lua`.

Ao pressionar `,`, o Neovim mostra um painel com os atalhos disponiveis. Os
grupos principais sao IA, Codigo, Debug, Git e Terminal.

### Gitsigns

Configurado em `lua/plugins/gitsigns.lua`.

- mostra sinais de linhas adicionadas, alteradas e removidas
- `]h` e `[h` navegam entre hunks
- `<leader>gs` faz stage do hunk
- `<leader>gr` reseta o hunk
- `<leader>gp` mostra preview do hunk
- `<leader>gb` mostra blame da linha
- `<leader>gd` abre diff do arquivo

### Todo comments

Configurado em `lua/plugins/todo_comments.lua`.

Destaca `TODO`, `FIXME`, `BUG`, `HACK`, `NOTE`, `INFO`, `WARN` e `WARNING`.
Use `<leader>td` para buscar essas marcacoes com Telescope.

### ToggleTerm

Configurado em `lua/plugins/toggleterm.lua`:

- tamanho 20
- direcao horizontal
- atalho nativo do plugin: `<C-\>`
- `<C-t>` abre o terminal horizontal para comandos do projeto
- `<leader>ai` abre o Codex em um terminal vertical lateral maior no diretorio atual
- `<leader>ac` abre o Codex no projeto atual
- `<leader>ar` reinicia o Codex
- `<leader>ak` fecha o Codex
- `<leader>tr` roda `python manage.py runserver`
- `<leader>tn` roda `npm run dev`
- `<leader>tg` ou `<leader>gt` abre lazygit
- o terminal comum e o terminal do Codex usam sessoes separadas
- o terminal comum fica no rodape; o Codex fica na lateral direita

### Persistence

Configurado em `lua/plugins/persistence.lua`.

- `<leader>qs` restaura a sessao do projeto atual
- `<leader>ql` restaura a ultima sessao
- `<leader>qd` desativa o salvamento da sessao atual

No dashboard, `s` tenta restaurar a sessao do projeto atual. Se o plugin nao
estiver disponivel, cai para `Telescope oldfiles`.

### Fugitive

Configurado em `lua/plugins/fugitive.lua`.

- `<leader>gg` abre `:Git`
- `<leader>gc` abre `:Git commit`
- `<leader>gP` executa `:Git push`
- `<leader>gl` executa `:Git pull`

### Bufferline

Configurado em `lua/plugins/bufferline.lua`:

- buffers numerados por ordem
- diagnosticos do LSP
- sem icones de fechar
- separador em estilo `slant`
- offset para o NvimTree com texto `File Explorer`

### Lualine

Configurado em `lua/plugins/lualine.lua`:

- statusline global
- mostra modo, branch, diff, diagnosticos, arquivo, encoding, formato, filetype,
  progresso e posicao
- desabilitado para `NvimTree`

## Tema Kaizen

O tema ativo esta em `lua/themes/cyberia.lua`.

O fundo base do tema Cyberia e:

```text
#080808
```

O tema antigo permanece em `lua/themes/kaizen.lua`.

Ele foi feito para combinar com o Alacritty atual:

| Uso | Cor |
| --- | --- |
| fundo | `#111318` |
| texto | `#E6EAF0` |
| comentarios/docstrings | `#5F6878` |
| strings | `#7ED7A8` |
| funcoes | `#8FB7FF` |
| keywords | `#C7A4FF` |
| types | `#79D7D2` |
| numeros/booleanos | `#FFB86C` |
| erros | `#FF6B6B` |
| avisos | `#F2C66D` |

O tema cobre grupos base do Vim, Treesitter, diagnostics, NvimTree, Telescope,
completion, Bufferline, statusline, floats e selecao.

## Markdown

Configurado em `lua/plugins/markdown.lua`:

- folding desativado
- conceal desativado
- frontmatter ativado

## Terminal

O terminal principal configurado no ambiente e o Alacritty.

Arquivo:

```text
~/.config/alacritty/alacritty.toml
```

Configuracao atual relevante:

- fonte: `JetBrainsMono Nerd Font`
- tamanho: `11.5`
- fundo: `#111318`
- texto: `#E6EAF0`
- opacidade: `1.0`
- padding: `x = 14`, `y = 12`
- decoracao de janela: `None`

## Comandos uteis

Abrir o gerenciador de plugins:

```vim
:Lazy
```

Sincronizar plugins:

```vim
:Lazy sync
```

Abrir Mason:

```vim
:Mason
```

Checar saude do Neovim:

```vim
:checkhealth
```

Formatar o buffer atual usando o LSP ativo:

```vim
:Format
```

Abrir diagnostics do buffer atual no quickfix:

```vim
:Lint
```

Recarregar a configuracao local sem fechar o Neovim:

```vim
:ReloadConfig
```

Executar arquivo atual:

```vim
:Run
```

## Observacoes

- O arquivo `lazy-lock.json` fixa as versoes dos plugins instalados.
- O `nvim-treesitter` esta fixado na branch `master`, pois ela mantem a API
  `nvim-treesitter.configs` usada pela configuracao atual.
- O Treesitter de Markdown fica bloqueado em `lua/plugins/markdown.lua` porque
  a branch classica do `nvim-treesitter` pode gerar erro de parser/injecao em
  versoes novas do Neovim. Markdown continua usando highlight nativo.
