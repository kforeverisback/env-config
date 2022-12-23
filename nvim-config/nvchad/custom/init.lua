-- See NVChad Lua for reference: https://nvchad.com/quickstart/Nvim%20lua
local vim = vim
-- Found whether to use vim.opt or vim.o using `:h vim.opt`
-- Apparently, vim.opt is the new way to do things for list and map type options
-- # For WSL, lets not use the system clipboard
-- For example see vim.opt.listchars
vim.opt.clipboard = "unnamed"
vim.opt.mouse = ""
vim.opt.number = true
vim.opt.numberwidth = 3
vim.opt.relativenumber = true -- shows line numbers relative to current line
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.timeoutlen = 400
vim.opt.updatetime = 250
vim.opt.undofile = true

-- " More natural splits
-- set splitbelow          " Horizontal split below current.
vim.opt.splitbelow = true
-- set splitright          " Vertical split to right of current.
vim.opt.splitright = true
-- if !&scrolloff
--     set scrolloff=3       " Show next 3 lines while scrolling.
-- endif
-- Using vim.o to get absolution value
if vim.o.scrolloff < 3 then
    vim.opt.scrolloff = 3
end
-- if !&sidescrolloff
--     set sidescrolloff=5   " Show next 5 columns while side-scrolling.
-- endif
if vim.o.sidescrolloff < 5 then
    vim.opt.sidescrolloff = 5
end
-- set nostartofline       " Do not jump to first character with page commands.
-- " Tell Vim which characters to show for expanded TABs,
-- " trailing whitespace, and end-of-lines. VERY useful!
-- if &listchars ==# 'eol:$'
--   set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
-- endif
if vim.o.listchars == 'eol:$' then
    vim.opt.listchars = {tab = '>\\' , trail = '-', extends = '>', precedes  ='<', nbsp ='+'}
    -- set list                " Show problematic characters.
    vim.opt.list = true
end
-- " Also highlight all tabs and trailing whitespace characters.
-- highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
-- match ExtraWhitespace /\s\+$\|\t/
-- set ignorecase          " Make searching case insensitive
vim.opt.ignorecase = true
-- set smartcase           " ... unless the query has capital letters.
vim.opt.smartcase = true
-- set gdefault            " Use 'g' flag by default with :s/foo/bar/.
-- " colorscheme murphy
