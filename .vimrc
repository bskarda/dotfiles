set nocompatible

filetype off
" Setting up Vundle - the vim plugin bundler
" from
" http://www.erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    let iCanHazVundle=0
endif
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

"only install YCM if OS is OS X
"let os = substitute(system('uname'), \"\n", \"", \"")
" TODO don't use YCM any more
"if os == \"Darwin"
"    Plugin 'Valloric/YouCompleteMe'
"endif

Plugin 'scrooloose/nerdtree' " sidebar file exploration
Plugin 'jistr/vim-nerdtree-tabs' " Allow nerdtree between tabs
" Plugin 'kien/ctrlp.vim' " Fuzzy searching
Plugin 'junegunn/fzf.vim'
" Plugin 'ervandew/supertab'
" Plugin 'scrooloose/syntastic'
Plugin 'w0rp/ale'
" Plugin 'majutsushi/tagbar' " side bar for displaying Ctags

" language specific
Plugin 'sheerun/vim-polyglot' " replaces all language specifics
"Plugin 'git://git.code.sf.net/p/vim-latex/vim-latex'
"Plugin 'https://github.com/jnwhiteh/vim-golang'
"Plugin 'fatih/vim-go'
"Plugin 'pangloss/vim-javascript'
"Plugin 'chaquotay/ftl-vim-syntax'
"Plugin 'puppetlabs/puppet-syntax-vim'

" git
Plugin 'tpope/vim-fugitive' " Dependency for visual git + nice git bindings
Plugin 'gregsexton/gitv' " visual git
Plugin 'airblade/vim-gitgutter' " Line status in gutter

" colors
" Plugin 'fugalh/desert.vim'
" Plugin 'altercation/vim-colors-solarized'
" Plugin 'vim-scripts/desert256.vim'
" Plugin 'Lokaltog/vim-distinguished'
" Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plugin 'chriskempson/base16-vim'

Plugin 'bronson/vim-trailing-whitespace' " highlight trailing whitepace

if iCanHazVundle == 0
    echo "Installing Plugins, please ignore key map error messages"
    echo ""
    :PluginInstall
endif
call vundle#end()
filetype plugin indent on
" End Vundle setup

syntax on

set t_Co=256 "terminal colors

set nu "line numbers
set ts=4
set expandtab "spaces instead of tab
set shiftwidth=4
syntax on
set ai "autoindent
set mouse=a
set hlsearch
set scrolloff=5
set ttyfast

" clipboard of osx
set clipboard=unnamed

set showmode
set showcmd

set wildmenu
set wildmode=list:longest

set laststatus=2

"Searching
set incsearch
set ignorecase
set smartcase

filetype plugin indent on

set statusline=%F[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P

" Faster updatetime to load git-gutter quickly
set updatetime=250

" augroup to prevent multiple autocmd definition from vimrc
augroup vimrc
    autocmd!
    " Protocol buffer syntax highlighting
    autocmd vimrc BufRead,BufNewFile *.proto setfiletype proto
    "autocmd VimEnter * NERDTree
    autocmd vimrc VimEnter * wincmd p
    autocmd vimrc bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
    " Markdown
    autocmd vimrc BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.md  set filetype=markdown
    " Disable folding in tex
    autocmd vimrc Filetype tex setlocal nofoldenable
    " autocmd vimrc BufEnter * nested :call tagbar#autoopen(0)
augroup end

" Nerdtree
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=0
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.pyc','\~$','\.swo$','\.swp$','\.git','\.hg','\.svn','\.bzr']
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0
map <C-n> :NERDTreeTabsToggle<CR>

" superTab removed because of YouCompleteMe
" set omnifunc=syntaxcomplete#Complete
" let g:SuperTabDefaultCompletionType = "<C-X><C-O>"

"set mapleader to be a better key than \
let g:mapleader=","

" Run this occasionally -> ctags -R -f ./.git/tags .
" or ctags -R .
"key bindings for ctags
" nnoremap <leader>b :TagbarToggle<CR>
" nnoremap <leader>. :CtrlPTag<CR>

"Colors
set background=dark
"colorscheme desert
"colorscheme desert256
"colorscheme solarized
"colorscheme distinguished
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-eighties

" added to fix backspace in OS X
set backspace=indent,eol,start

" Enable tab completion from tag file
" let g:ycm_collect_identifiers_from_tags_files = 1

" more natural splits
set splitbelow
set splitright

" syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 0
"let g:syntastic_ruby_checkers = ['mri', 'rubocop']

" FZF helper to transition from ctrl-p
map <C-p> :Files<CR>

" enable mouse resize within tmux
" This breaks neovim
set ttymouse=xterm2

" command history
set history=10000

" FZF
set rtp+=/usr/local/opt/fzf
