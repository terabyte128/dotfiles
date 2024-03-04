set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}
" Plugin 'davidhalter/jedi-vim'
" Plugin 'ycm-core/YouCompleteMe'
Plugin 'hashivim/vim-terraform'
" Plugin 'psf/black', { 'tag': '19.3b0' }
Plugin 'nvie/vim-flake8'
" Plugin 'dense-analysis/ale'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'altercation/vim-colors-solarized'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'alvan/vim-closetag'
Plugin 'google/vim-jsonnet'
Plugin 'normen/vim-pio'
" Plugin 'easymotion/vim-easymotion'
Plugin 'iamcco/markdown-preview.nvim'
Plugin 'windwp/nvim-autopairs'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
set autoindent
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
" highlight lines that are too long
" NOTE: not used because it also highlights code completion :(
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/
"
" Put a line at 81 cols (max length 80 else black else flake8 will complain)
set colorcolumn=80
highlight colorcolumn ctermbg=7 " highlight in neutral gray

" Highlight syntax
syntax on

" Run black and flake8 on python files when saving
" autocmd BufWritePre *.py execute ':Black'
" autocmd BufWritePost *.py call flake8#Flake8()

"autocmd BufWritePre *.go execute ':YcmCompleter Format'

" Allow YCM config files in my home directory to be auto-run
let g:ycm_extra_conf_globlist = ["/home/samwolfson/*"]

" allow backspace to delete previous inserts and across line breaks
set backspace=indent,eol,start

" black venv location
let g:black_virtualenv = "/home/samwolfson/black-env/.venv"
let g:black_linelength = 80

" enable folding
set fdm=indent
set foldlevelstart=20

" COC config
source $HOME/.config/nvim/coc-config.vim

" hecc tabs
set tabstop=4
set expandtab
set shiftwidth=4

" ALE stuff
let g:ale_echo_msg_format = '%linter%: %s'
let g:ale_linters = {"python": ["pyright", "flake8"], "go": ["golint"]}
let g:ale_python_mypy_options = "--ignore-missing-imports --follow-imports=silent"

set ruler

" detect python workspace root by looking for .venv
autocmd FileType python let b:coc_root_patterns = [".envrc", ".venv"]

" format python on save
autocmd filetype python autocmd BufWritePre * call CocAction('format')

" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
autocmd colorscheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
match ExtraWhitespace /\s\+$/


" remove trailing whitespace on save except for hunks
let ftIgnore = ['diff']
autocmd BufWritePre * if index(ftIgnore, &ft) < 0 | :%s/\s\+$//e

function FormatTf()
    let pos = getpos(".")
    silent %!terraform fmt -
    call setpos(".", pos)
endfunction

autocmd filetype tf,terraform autocmd BufWritePre * call FormatTf()
autocmd FileType tf,terraform let b:coc_root_patterns = ["TENANT", "dev.tf", "stage.tf", "production.tf", "modules", "main.tf", "networking", "versions.tf"]

colorscheme solarized
set background=light
set number

let g:closetag_filetypes = 'html,javascriptreact,typescriptreact'

let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

" don't scroll all the way to the bottom
set scrolloff=8
" clear highlighting after escape pressed
map <esc> :noh <CR>

" sort imports with leader-s-i
map <leader>si :CocCommand python.sortImports<CR>

autocmd FileType gitcommit,markdown setlocal spell

" snippets
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/snippets']
let g:UltiSnipsExpandTrigger="<c-s>"

function FormatPacker()
    :silent !packer fmt <afile>
    :e
endfunction

autocmd BufWritePost *.pkr.hcl call FormatPacker()

autocmd filetype rst,md set textwidth=80

nmap <leader>ff :Files<CR>
nmap <leader>gF :GFiles?<CR>
nmap <leader>gf :GFiles<CR>

command Apply :w !kubectl apply -f -

set autochdir " edit relative to current dir

function! ApplyThis()
    let lineno = line(".")
    let filepath = expand("%:p")

    let foo = system("kapply " .. lineno .. " " .. filepath)
    echo foo
endfunction

function! GitlabLink(branch)
    let filepath = expand("%:p")
    let lineno = line(".")
    let root = trim(system("git rev-parse --show-toplevel"))

    let reponame = split(root, "/")[-1]

    let filepathlen = strlen(filepath)
    let rootlen = strlen(root)

    let relativepath = strpart(filepath, rootlen, filepathlen)

    if a:branch == ""
        let sha = trim(system("git rev-parse --short HEAD"))
    elseif a:branch == "__default"
        " https://stackoverflow.com/questions/28666357/how-to-get-default-git-branch
        " to update local cache of default branch from remote:
        " git remote set-head origin -a
        let sha = split(trim(system("git rev-parse --abbrev-ref origin/HEAD")), "/")[-1]
    else
        let sha = a:branch
    endif

    let gitlab = "https://gitlab.i.extrahop.com/core/" .. reponame .. "/-/blob/" .. sha .. relativepath .. "#L" .. lineno

    echo gitlab
endfunction

command GitlabLink :call GitlabLink('')
command GitlabLinkDefault :call GitlabLink('__default')

autocmd FileType cpp :set shiftwidth=2
command Upload :w | !pio run --target upload
nmap <leader>o o<Esc>k
nmap <leader>O O<Esc>j

let g:mkdp_port = 12345
function OpenMarkdownPreview (url)
    echo a:url
endfunction
let g:mkdp_browserfunc = 'OpenMarkdownPreview'

lua <<EOF
local npairs = require('nvim-autopairs')
npairs.setup({ map_cr = false })
EOF

" source $HOME/.config/nvim/setup-autopairs.lua
