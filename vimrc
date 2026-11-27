set nocompatible

" Load the plugins next to this vimrc, wherever the checkout is synced.
let s:config_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:is_ivim = has('ios') || exists(':ipreview') == 2
if s:is_ivim
  let g:pathogen_blacklist = get(g:, 'pathogen_blacklist', get(g:, 'pathogen_disabled', []))
  if index(g:pathogen_blacklist, 'previm') == -1
    let g:pathogen_blacklist = g:pathogen_blacklist + ['previm']
  endif
endif
execute 'source ' . fnameescape(s:config_dir . '/pathogen/autoload/pathogen.vim')
execute pathogen#infect(s:config_dir . '/{}')

syntax on
filetype plugin indent on

" Some basic options
set completeopt=noinsert,menuone,noselect
set history=500
set showcmd
set smartcase
set ignorecase
set showmatch
set incsearch
set nostartofline
set fileencoding=utf-8
set nowrap
set linebreak
set listchars=tab:\ \ ,trail:·
set list
set lazyredraw
" set background=dark
set hidden
set conceallevel=2 concealcursor=
set splitright
set splitbelow
set path+=**
set fillchars+=vert:\│
set synmaxcol=5000

" set exrc
" set secure

" Recommended for vim-stay
set sessionoptions-=cursor,folds,slash,unix

" No swap files, but undo files
set noswapfile
set nobackup
set nowritebackup
set undodir=~/backups
set undofile

" Some of my favourites
" colorscheme PaperColor
" colorscheme seoul
" colorscheme abstract
" colorscheme afterglow
" colorscheme scheakur
" colorscheme darkblue
colorscheme onedark
"ifont iosevka-fixed-ss04-extended 18

let mapleader=","
let maplocalleader=","

" Vimtex ------------------------------
let g:vimtex_compiler_enabled=0
set conceallevel=2

let g:vimtex_toc_config = { 'show_help' : 0, 'refresh_always' : 1, 'todo_sorted' : 0 }

augroup vimtex
  autocmd!
  autocmd BufWritePost *.tex call vimtex#toc#refresh()
augroup END

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

function! Prose()
  " call pencil#init()
  call pencil#init({'wrap': 'soft'})
  call lexical#init()
  " call litecorrect#init()
  call textobj#quote#init()
  call textobj#sentence#init()

  " manual reformatting shortcuts
  nnoremap <buffer> <silent> Q gqap
  xnoremap <buffer> <silent> Q gq
  nnoremap <buffer> <silent> <leader>Q vapJgqap

  " force top correction on most recent misspelling
  " nnoremap <buffer> <c-s> [s1z=<c-o>
  " inoremap <buffer> <c-s> <c-g>u<Esc>[s1z=`]A<c-g>u

  " replace common punctuation
  " iabbrev <buffer> -- –
  " iabbrev <buffer> --- —
  " iabbrev <buffer> << «
  " iabbrev <buffer> >> »

  " open most folds
  " setlocal foldlevel=6

  " replace typographical quotes (reedes/vim-textobj-quote)
  map <silent> <buffer> <leader>qc <Plug>ReplaceWithCurly
  map <silent> <buffer> <leader>qs <Plug>ReplaceWithStraight

  " highlight words (reedes/vim-wordy)
  " noremap <silent> <buffer> <F8> :<C-u>NextWordy<cr>
  " xnoremap <silent> <buffer> <F8> :<C-u>NextWordy<cr>
  " inoremap <silent> <buffer> <F8> <C-o>:NextWordy<cr>
  "
  set conceallevel=2 concealcursor=i

endfunction "

" Markdown preview ------------------------------
if !s:is_ivim
  let g:previm_custom_preview_base_dir = get(g:, 'previm_custom_preview_base_dir', tempname())
  if !exists('g:previm_open_cmd')
    if has('win32')
      let g:previm_open_cmd = 'start ""'
    elseif has('macunix')
      let g:previm_open_cmd = 'open'
    elseif executable('xdg-open')
      let g:previm_open_cmd = 'xdg-open'
    endif
  endif
endif

function! s:PreviewMarkdown() abort
  if exists(':ipreview') == 2
    ipreview
  elseif s:is_ivim
    echomsg 'Markdown preview requires an iVim version with :ipreview.'
  elseif exists(':PrevimOpen') == 2
    PrevimOpen
  else
    echomsg 'Markdown preview requires Previm. Run git submodule update --init previm from the config checkout and restart Vim.'
  endif
endfunction

function! s:SetupMarkdownPreview() abort
  command! -buffer PreviewMarkdown call <SID>PreviewMarkdown()
  nnoremap <buffer> <silent> <leader>p :<C-u>PreviewMarkdown<CR>
  let l:undo = 'silent! delcommand -buffer PreviewMarkdown | silent! nunmap <buffer> <leader>p'
  let b:undo_ftplugin = exists('b:undo_ftplugin') ? b:undo_ftplugin . ' | ' . l:undo : l:undo
endfunction

augroup markdown_preview
  autocmd!
  autocmd FileType markdown,mkd call s:SetupMarkdownPreview()
augroup END

" File Types ------------------
" automatically initialize buffer by file type
autocmd FileType markdown,mkd call Prose()

autocmd FileType tex hi link texItalStyle Underlined
autocmd FileType tex call Prose()
autocmd FileType tex set conceallevel=2 concealcursor=

set foldmethod=expr
set foldexpr=vimtex#fold#level(v:lnum)
set foldtext=vimtex#fold#text()

" invoke manually by command for other file types
command! -nargs=0 Prose call Prose()

" Mappings ------------------------------
"
let g:ctrlp_working_path_mode = 'ra'
map <leader>f :CtrlP<cr>
map <leader>F :CtrlPCurFile<cr>
map <leader>b :CtrlPBuffer<cr>
map <leader>m :CtrlPBookmark<cr>


" In insert or command mode, move normally by using Ctrl
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

" Font sizes
nnoremap <c-0> :ifont +<cr>
nnoremap <c-9> :ifont -<cr>

let g:goyo_width = 80
let g:goyo_height = "100%"
nnoremap <c-8> :Goyo<cr>
nnoremap <c-1> :call SynGroup()<cr>

" I'm so used to doing this...
nmap <c-s> :w<cr>


" vim: fdm=marker

set mouse=

