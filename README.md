# projetos-nvim-dev-full

Configuração pessoal de **Neovim** para desenvolvimento full-stack, escrita em **Lua** e organizada em módulos gerenciados pelo **[lazy.nvim](https://github.com/folke/lazy.nvim)**. Vem com LSP, autocompletion, tree-sitter, telescope, file tree, formatação automática, status line, diagnóstico visual e tema Catppuccin — pronta para editar TypeScript/JavaScript, Python, C/C++, HTML/CSS e JSON.

O repositório distribui a configuração como **`init.lua`** (bootstrap) + **`lua.zip`** (módulos), que precisa ser extraído em `~/.config/nvim/lua/`.

---

## Sumário

- [Requisitos](#requisitos)
- [Instalação](#instalação)
- [Estrutura da configuração](#estrutura-da-configuração)
- [Plugins incluídos](#plugins-incluídos)
- [Servidores LSP pré-configurados](#servidores-lsp-pré-configurados)
- [Opções do editor](#opções-do-editor)
- [Atalhos (keymaps)](#atalhos-keymaps)
- [Personalização](#personalização)
- [Solução de problemas](#solução-de-problemas)
- [Licença](#licença)

---

## Requisitos

- **Neovim ≥ 0.9** (recomendado 0.10+)
- **git** — necessário para o bootstrap do lazy.nvim
- **make** e um compilador C (`gcc`/`clang`) — para o `telescope-fzf-native`
- **Node.js** e **npm** — para os servidores LSP de JS/TS/HTML/CSS/JSON via Mason
- **Python 3** — para o `pyright` via Mason
- (Opcional) **[Neovide](https://neovide.dev/)** — a config já traz keymaps de zoom (`Ctrl+=`, `Ctrl+-`, `Ctrl+0`)
- (Opcional) **Nerd Font** — para os ícones do `nvim-web-devicons` e do statusline

---

## Instalação

### Backup da configuração atual (recomendado)

```bash
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null || true
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null || true
```

### Clonar e instalar

```bash
git clone https://github.com/Kobayashi24730/projetos-nvim-dev-full.git
cd projetos-nvim-dev-full

mkdir -p ~/.config/nvim
cp init.lua ~/.config/nvim/
unzip lua.zip -d ~/.config/nvim/
```

A árvore final deve ficar assim:

```
~/.config/nvim/
├── init.lua
└── lua/
    ├── config/
    │   └── options.lua
    └── plugins/
        ├── autocomplete.lua
        ├── lsp.lua
        ├── telescope.lua
        ├── theme.lua
        ├── tree.lua
        └── ui.lua
```

### Primeiro boot

Abra o Neovim: `nvim`.

Na primeira execução o **lazy.nvim** faz self-bootstrap (clone em `~/.local/share/nvim/lazy/lazy.nvim`), instala todos os plugins e o **Mason** baixa os servidores LSP declarados. Aguarde a instalação terminar e reinicie.

Comandos úteis:

- `:Lazy` — dashboard do gerenciador de plugins
- `:Mason` — dashboard dos LSPs / linters / formatters
- `:checkhealth` — diagnóstico geral do ambiente

---

## Estrutura da configuração

- **`init.lua`** — bootstrap do lazy.nvim, define `<leader> = " "` (espaço) e carrega os módulos.
- **`lua/config/options.lua`** — opções básicas do editor (números, indentação, cores).
- **`lua/plugins/*.lua`** — cada arquivo devolve uma spec de plugins para o `lazy.setup(...)`.

O `init.lua` faz `unpack(...)` de cada módulo, então cada arquivo pode declarar múltiplos plugins e um único bloco `config` de setup compartilhado.

---

## Plugins incluídos

Agrupados por módulo:

### `autocomplete.lua`
- [`nvim-cmp`](https://github.com/hrsh7th/nvim-cmp) + sources: `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `cmp_luasnip`
- [`LuaSnip`](https://github.com/L3MON4D3/LuaSnip) — engine de snippets
- [`nvim-autopairs`](https://github.com/windwp/nvim-autopairs) — fecha pares automaticamente
- [`conform.nvim`](https://github.com/stevearc/conform.nvim) — formatação (integrada com fallback LSP)

### `lsp.lua`
- [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig)
- [`mason.nvim`](https://github.com/williamboman/mason.nvim) + [`mason-lspconfig`](https://github.com/williamboman/mason-lspconfig.nvim)
- [`lspkind.nvim`](https://github.com/onsails/lspkind.nvim) — ícones nas sugestões
- [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) (com `:TSUpdate` no build)
- Diagnósticos com ícones custom e `virtual_text` com prefixo `●`

### `telescope.lua`
- [`telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim) + `plenary.nvim`
- [`telescope-fzf-native.nvim`](https://github.com/nvim-telescope/telescope-fzf-native.nvim) (build: `make`)

### `tree.lua`
- [`nvim-tree.lua`](https://github.com/nvim-tree/nvim-tree.lua) + `nvim-web-devicons`

### `ui.lua`
- [`lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim) — status line
- [`trouble.nvim`](https://github.com/folke/trouble.nvim) — painel de diagnósticos

### `theme.lua`
- [`catppuccin/nvim`](https://github.com/catppuccin/nvim) — tema padrão (aplicado com `priority = 1000`)
- Atalhos de zoom para Neovide

---

## Servidores LSP pré-configurados

Instalados automaticamente via `mason-lspconfig.ensure_installed`:

| Servidor  | Linguagens             |
|-----------|------------------------|
| `pyright` | Python                 |
| `ts_ls`   | TypeScript / JavaScript|
| `html`    | HTML                   |
| `cssls`   | CSS                    |
| `jsonls`  | JSON                   |
| `clangd`  | C / C++                |

Cada servidor é setado com as `capabilities` do `cmp-nvim-lsp`, então a integração com o completion já vem pronta.

---

## Opções do editor

Definidas em `lua/config/options.lua`:

| Opção            | Valor                       | Efeito                                        |
|------------------|-----------------------------|-----------------------------------------------|
| `autowrite`      | `true`                      | Salva o buffer ao trocar de arquivo           |
| `number`         | `true`                      | Números de linha                              |
| `relativenumber` | `true`                      | Números relativos ao cursor                   |
| `termguicolors`  | `true`                      | Cores true-color no terminal                  |
| `expandtab`      | `true`                      | Tab vira espaços                              |
| `shiftwidth`     | `2`                         | Indentação com 2 espaços                      |
| `tabstop`        | `2`                         | Tab renderizado como 2 espaços                |
| `completeopt`    | `menu,menuone,noselect`     | Comportamento do menu de completion           |

---

## Atalhos (keymaps)

`<leader>` = **Espaço**.

### Navegação e busca

| Atalho        | Ação                          |
|---------------|-------------------------------|
| `<leader>f`   | Telescope — find files        |
| `<leader>g`   | Telescope — live grep         |
| `<leader>e`   | Toggle do NvimTree            |
| `<leader>xx`  | Trouble — abrir/fechar painel |

### LSP

| Atalho        | Ação                          |
|---------------|-------------------------------|
| `gd`          | Ir para definição             |
| `K`           | Hover / documentação          |
| `gr`          | Referências                   |
| `<leader>rn`  | Renomear símbolo              |
| `<leader>ca`  | Code action                   |
| `<leader>ff`  | Formatar via LSP              |
| `<leader>fm`  | Formatar via `conform` (com fallback LSP) |

### Autocompletion (modo Insert)

| Atalho        | Ação                          |
|---------------|-------------------------------|
| `<Tab>`       | Próximo item                  |
| `<S-Tab>`     | Item anterior                 |
| `<CR>`        | Confirmar seleção             |
| `<C-Space>`   | Abrir menu manualmente        |

### Neovide (opcional)

| Atalho     | Ação                       |
|------------|----------------------------|
| `<C-=>`    | Zoom +0.1                  |
| `<C-->`    | Zoom −0.1                  |
| `<C-0>`    | Reset do zoom (1.0)        |

---

## Personalização

- **Adicionar um plugin:** crie um novo arquivo em `lua/plugins/` retornando uma tabela (spec do lazy.nvim) e registre-o no `init.lua`:

  ```lua
  require("lazy").setup({
    unpack(require("plugins.autocomplete")),
    unpack(require("plugins.meu_plugin")),  -- <- novo
    ...
  })
  ```

- **Novo LSP:** adicione o nome do server em `ensure_installed` dentro de `lua/plugins/lsp.lua` (nome válido do Mason).

- **Trocar tema:** substitua o spec em `lua/plugins/theme.lua` e ajuste a linha `vim.cmd.colorscheme "..."`.

- **Mudar leader:** edite `vim.g.mapleader = " "` em `init.lua` (precisa estar antes do carregamento dos plugins).

---

## Solução de problemas

- **`telescope-fzf-native` falha no build** → verifique se `make` e um compilador C estão instalados no PATH; rode `:Lazy build telescope-fzf-native.nvim`.
- **LSP não sobe** → abra `:Mason` e confirme que o server aparece como instalado. Rode `:LspInfo` no buffer alvo.
- **Ícones aparecem como caixas / interrogações** → instale uma Nerd Font e configure-a no seu terminal.
- **Erro `module 'plugins.autocomplete' not found`** → o `lua.zip` não foi extraído para `~/.config/nvim/lua/`. Confira a árvore mostrada em [Instalação](#instalação).
- **Depois de mexer nos plugins** → `:Lazy sync` para atualizar e `:Lazy clean` para remover órfãos.

---

## Licença

- **Distribuído sob a licença MIT. Veja o arquivo LICENSE para o texto completo.**
