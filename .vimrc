filetype plugin on

set encoding=utf-8


call plug#begin()
  Plug 'lervag/vimtex'
  Plug 'neoclide/coc.nvim', {'branch':'release'}
  Plug 'neoclide/coc-vimtex'
  Plug 'tpope/vim-surround'
  " Language server + completion
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " Python-specific extras
  Plug 'vim-python/python-syntax'
  Plug 'vim-scripts/indentpython.vim'

  " Interactive
  Plug 'jpalardy/vim-slime'

  " UI
  Plug 'vim-airline/vim-airline'
  Plug 'junegunn/fzf.vim'

  " Autosave
  Plug '907th/vim-auto-save'

  " Color scheme
  Plug 'sheerun/vim-polyglot'  

  " Markdown plugins
  Plug 'preservim/vim-markdown'
  Plug 'junegunn/vim-markdown-toc'
  Plug 'godlygeek/tabular'
  
call plug#end()

let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

inoremap jk <Esc>

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-y>" :
      \ coc#expandable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand',''])<CR>" :
      \ "\<Tab>"

inoremap <CapsLock> <Esc>
nmap oo o<Esc>k

" Popup menu styling: dark background, blue selection
highlight Pmenu      ctermfg=white  ctermbg=darkgray guifg=#ffffff guibg=#1e1e1e
highlight PmenuSel   ctermfg=white  ctermbg=blue     guifg=#ffffff guibg=#005fdf
highlight PmenuSbar  ctermbg=darkgray guibg=#333333
highlight PmenuThumb ctermbg=lightgray guibg=#888888
highlight SignColumn ctermbg=0 ctermfg=NONE
" Coc.nvim floating window styling (to match popup)
highlight CocMenuSel guibg=#005fdf guifg=#ffffff
highlight CocFloating guibg=#1e1e1e guifg=#ffffff

" Enable block cursor in Normal mode and beam in Insert mode
if &term =~ 'xterm'
  let &t_SI = "\e[6 q"   " Insert mode: beam
  let &t_EI = "\e[2 q"   " Normal mode: block
endif

" Enable Python support in coc
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
" Tell vim-slime to use tmux by default
let g:slime_target = "tmux"

highlight pythonComment ctermfg=LightBlue guifg=#ADD8E6

let g:auto_save = 1

nnoremap md :w<CR>:!python ~/md2html.py %<CR>
nnoremap tc :UpdateToc<CR>

let g:vmt_auto_update_on_save = 0
set nofoldenable

nnoremap <leader>g :!bash -i -c 'gup'<CR>

