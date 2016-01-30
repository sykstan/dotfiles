" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc


"so I recently (Sat 29 Aug 2015) changed the way my Vim works
"previously I had a Vim folder in Dropbox and that contained 
"the my vimrc.vim and the plugins I installed. 
"Now I've decided to use Vundle to manage my plugins, and also
"I'm switching from Dropbox to Github for my vimrc.vim
"The idea is I clone https://github.com/sykstan/dotfiles.git
"in my $HOME, ln -s the vimrc.vim there to $HOME/.vimrc
"and then it will set up ~/.vim/ the same way across different 
"systems. This will hopefully be much simpler than the MySys()
"function method of determining where I was and adding Dropbox/Vim
"to the runtimepath. Plugins will still be in .vim/bundle/

" pathogen (Thur 27 March 2014)
" using Vundle now (Sat 29 Aug 2015)
"execute pathogen#infect()

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

"""""" here begins the Vundle section """""""""
" begin by installing Vundle on new systems
"git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
filetype off   " required

" set the runtime path to include Vundle and initialize
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"" The following are examples of different formats supported.
"" Keep Plugin commands between vundle#begin/end.
"" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
"" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
"" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
"" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
"" The sparkup vim script is in a subdirectory of this repo called vim.
"" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
"" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}

"""" my plugins :)
" Slimv, for Common Lisp / Scheme
Plugin 'vim-scripts/slimv.vim'
" vim-latex
Plugin 'vim-latex/vim-latex'
" NERD-tree
Plugin 'scrooloose/nerdtree'
" Conque Shell, run interactive programs in Vim buffer
"Plugin 'vim-scripts/Conque-Shell'
" currently the above doesn't work, using this fork in the meantime
Plugin 'lrvick/Conque-Shell'

""" colorschemes!! """
Plugin 'mhumeSF/one-dark.vim'
Plugin 'atweiden/vim-colors-behelit'
Plugin 'dfxyz/CandyPaper.vim'
Plugin 'dsolstad/vim-wombat256i'
Plugin 'cocopon/iceberg.vim'
Plugin 'marlun/vim-starwars'    "darth & leya
Plugin 'noahfrederick/vim-hemisu'
Plugin 'chriskempson/vim-tomorrow-theme'    "Tomorrow-Night-{Blue|Bright|Eighties|Night}
Plugin 'goatslacker/mango.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
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
""""""""""""" end Vundle section """"""""""""""""""

" to start NERDTree
map <F2> :NERDTreeToggle

" set colorscheme 
"colorscheme torte   " good default
colorscheme Tomorrow-Night-Bright


" set the <leader> key, this was previously unset
" but I need it for the vim-latex plugin
" backslash is the default, the comma is also pretty common
" the extra backslash is for escaping
"let mapleader="\\"
" try comma
let mapleader = ","

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif


" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif

" backup directory for .ext~ files (Thurs 8 Aug 2013)
" for swap files (.ext.swp), it is 'set directory='
set backupdir=$HOME/.vim/backups

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=100

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" #########################################################
" My personal section of preferred settings
" #########################################################
" usually have this on Dropbox 
" add this to ~/.vimrc 
" for Miststone (general home box)
"function! MySys()
"    return "general_home"
"endfunction
"
"set runtimepath+=$HOME/Dropbox/Vim
"source $HOME/Dropbox/Vim/vimrc.vimis to ~/.vimrc to source my vimrc file
"
" what I do is place this in Dropbox/Vim as vimrc.vim
" and then in ~/.vimrc (in my home folder) I link to
" this file by having the following lines
" set runtimepath+=~/Dropbox/Vim
" source ~/Dropbox/Vim/vimrc.vim
"
" %%% General Layout %%%
" ----------------------
" indentation and whitespace
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4

" I like line numbers to be visible 
" hybrid line numbers
set number
set relativenumber

" this ensures that Ctrl-c copies to the system clipboard/buffer
" so that I can use visual block selection conveniently
" otherwise, y copies to the vim buffer, and the mouse/GUI gestures
" copies to system buffer, but I can't use the mouse to get block selection
map <C-c> "+y<CR>


" vim uses the monospace font determine by system settings
" I like gvim to use something other than Monospace
" (It doesn't follow the system defined font, can't
"  seem to figure out where it's getting it from)
" Anyway,...
"set guifont=DejaVu\ Sans\ Mono\ 9

""""""""" MY KEYBINDINGS """"""""""""""
" inserts newline in normal mode
nnoremap nl o<Esc>
nnoremap NL O<Esc>
" NERDTree
map <F2> :NERDTreeToggle<CR>
noremap <Leader>nt :NERDTreeToggle<CR>


" turns on both cursor highlights;
nnoremap <leader>c :set cursorline! cursorcolumn! <CR>

" ii escapes to normal mode
" could remap Caps_Lock to Esc
" using xmodmap like this
" xmodmap -e 'clear lock' -e 'keycode 0x42 = Escape'
" use xmodmap and xev to check results
"inoremap ii <Esc>

" switch buffers easily
:nnoremap <F5> :buffers<CR>:buffer<Space>

""""""""" END KEYBINDINGS """""""""""""


" some useful tweaks
"
" have a wildmenu in command mode
set wildmenu wildmode=longest:full,full

 " refer to keybinding above
hi Cursorline     guibg=DarkRed
hi Cursorcolumn   ctermbg=black guifg=lightgrey gui=bold,italic

" get rid of annoying beeps and flashes
set visualbell noeb t_vb=


" Only set these when at home
" on the NCI and MSG these will be turned off
" since they complain
"
"if (MySys()=="home")
"    " can undo even if file is closed and reopened
"    set undofile
"
"    "" disable arrow keys !! (Fri 13 April 2012)
"    "nnoremap <up> <nop>
"    "nnoremap <down> <nop>
"    "nnoremap <left> <nop>
"    "nnoremap <right> <nop>
"    "inoremap <up> <nop>
"    "inoremap <down> <nop>
"    "inoremap <left> <nop>
"    "inoremap <right> <nop>
"
"    " shows when code gets too long
"    set colorcolumn=85
"
"
"else  "for MSG and NCI
"    "inform the guard for the taglist plugin
"    "not to load, as this variable is already defined
"    let loaded_taglist = 1
"
"endif

""""""""" search and replace """"""""""
" search case insensitive unless containing capitals
set ignorecase
set smartcase

" assume global (g) substitution
set gdefault

""""""""" long lines """"""""""""""""""
set wrap
" also see set colorcolumn in MySys conditional

"""""""" autosave if lose focus """""""
au FocusLost * :wa


" toggle paste to F3 (Wed 11 July 2012)
map <F3> :set invpaste<CR>
set pastetoggle=<F3>

" for preserving folding (Thurs 19 July 2012)
" added ? in front of * to silence errors (Wed 2 Sept 2015)
au BufWinLeave ?* mkview 1
au BufWinEnter ?* silent loadview 1

"""""""" LaTeX-Suite """""""""""""""""
" LaTeX-suite recommendations (Thur 27 March 2014)
" grep sometimes skips displaying the file name when searching
" a single file; this confuses LaTeX-suite.
" make grep always generate a file-name
"set grepprg = grep\ -nH\ $*

" default is to load .tex files as 'plaintex', make it 'tex'
let g:tex_flavor = 'latex'

" (Tue 20 May 2014)
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_MultipleCompileFormats='pdf, aux'

" no fancy arrow characters for NERDTree (Mon 31 Aug 2015)
" or just do export LC_ALL=en_US.utf-8; export LANG="$LC_ALL" in .bashrc
"let g:NERDTreeDirArrows=0
"
"
""""""""" Code Development """""""""""""
" map F4 to run current file in bash
map <F4> :!bash % <CR>
" and F6 to Python3
map <F6> :!python3 % <CR>
