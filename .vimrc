set nocp
set vb t_vb=
set sw=4 sts=4
set et
set backspace=indent,eol,start
set autoindent
set showcmd showmode
set hidden
set laststatus=2
set pastetoggle=<F5>
set statusline=[%02n]\ %(%M%R%H%)\ %F\ %=<%l,%c%V>\ %P
set wildmenu
set is ic hls
set sm
set dir=/tmp///
set mps+=<:>
set bg=dark
set mouse=
set backupcopy=yes

set so=3
set cursorline

"let &termencoding=&encoding
"set encoding=utf-8

syntax on
filetype indent on
filetype plugin on

map ,v :e ~/.vimrc<CR>
map ,u :so ~/.vimrc<CR>
map ,ceol :%s/\s\+$//

nmap Y y$

autocmd BufEnter * lcd %:p:h 
autocmd BufNewFile,BufRead *.py map <buffer> <F12> :w!<cr>:!python %<cr>
autocmd BufNewFile,BufRead *.py imap <buffer> <F12> <esc>:w!<cr>:!python %<cr>
autocmd BufNewFile,BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufNewFile,BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
autocmd BufNewFile,BufRead *.py nmap <buffer> <F11> :w!<cr>:make<cr>
autocmd BufNewFile,BufRead *.py imap <buffer> <F11> <esc>:w!<cr>:make<cr>
autocmd BufNewFile,BufRead *.py map <buffer> <leader>c :cope 5<cr>
