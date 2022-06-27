" An example for a vimrc file.
"
" Maintainer:	Shubham Shinde <https://gist.github.com/shubham-shinde>
" Last change:	2019 12 20
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.

" let $VIMRUNTIME="/usr/share/vim/vim82"

if v:progname =~? "evim"
  finish
endif

" ================ General Config ====================
" Here is what I wrote ----------
" auto reload file on update
let mapleader=","
inoremap jk <ESC>
set autoread
set mouse=a
" au CursorHold * checktime
set dir=~/tmp
set number relativenumber
set splitbelow splitright
set history=1000
set visualbell
noremap <Leader>, :update<CR>
set updatetime=300

" Show Invisibles
set list
" set listchars=tab:→→,eol:¬,space:.
" set list listchars=tab:\ \ ,trail:·
set showbreak=↪\
set listchars=eol:¬,tab:│→\,nbsp:␣,trail:•,extends:⟩,precedes:⟨,space:·

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" To remove remaining spaces
autocmd BufWritePre * %s/\s\+$//e

" ================ No compatible mode ==============
set nocp

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb
set nowritebackup
" Give more space for displaying messages.
set shortmess+=c

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=8       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:longest,full
" set completeopt+=longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=node_modules
set wildignore+=/node_modules
set wildignore+=**/node_modules
set wildignore+=node_modules/**
set wildignore+=**/node_modules/**
set wildignore+=*/node_modules/*

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

" ================ Indentation ======================

" set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
" set expandtab

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

filetype plugin on
filetype indent on

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points


" Get the defaults that most users want.
" source $VIMRUNTIME/defaults.vim

" ================ File specific ===========================
augroup configgroup
  autocmd!
  autocmd VimEnter * highlight clear SignColumn
  " autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
        " \:call <SID>StripTrailingWhitespaces()
  autocmd FileType java setlocal noexpandtab
  autocmd FileType java setlocal list
  autocmd FileType java setlocal listchars=tab:+\ ,eol:-
  autocmd FileType java setlocal formatprg=par\ -w80\ -T4
  autocmd FileType php setlocal expandtab
  autocmd FileType php setlocal list
  autocmd FileType php setlocal listchars=tab:+\ ,eol:-
  autocmd FileType php setlocal formatprg=par\ -w80\ -T4
  autocmd FileType ruby setlocal tabstop=2
  autocmd FileType ruby setlocal shiftwidth=2
  autocmd FileType ruby setlocal softtabstop=2
  autocmd FileType ruby setlocal commentstring=#\ %s
  autocmd FileType python setlocal commentstring=#\ %s
  autocmd BufEnter *.cls setlocal filetype=java
  autocmd BufEnter *.zsh-theme setlocal filetype=zsh
  autocmd BufEnter Makefile setlocal noexpandtab
  autocmd BufEnter *.sh setlocal tabstop=2
  autocmd BufEnter *.sh setlocal shiftwidth=2
  autocmd BufEnter *.sh setlocal softtabstop=2
augroup END

" erb file as html
autocmd BufNewFile,BufRead *.html.erb set filetype=html

autocmd filetype cpp map <Leader>rr :!bash -c "g++-11 -std=c++17 -Wall % -o %:r.exe && %:r.exe < %:r.test > %:r.out"<CR>

function! CreateCPFiles(line)
	let current_path =expand('%:p:h') " /maindir/subdir
	let path =current_path.'/'.a:line " /maindir/subdir/name
	let file_name =a:line " name
	let file_path =path.'/'.file_name " /maindir/subdir/name/name
	" touch /maindir/subdir/name/name.cpp /maindir/subdir/name/name.out /maindir/subdir/name/name.in
	let touch ='touch '.file_path.'.cpp '.file_path.'.test '.file_path.'.out'
	" echo touch
	execute(':!bash -c "mkdir '.path.' && '.touch.'"' )
	" fill template to file if file is empty
	execute(':!bash -c "[[ -s '.file_path.'.cpp ]] || cat ~/.vim.cpp > '.file_path.'.cpp"' )
	execute(':edit '.file_path.'.cpp')
	execute(':vsplit '.file_path.'.test')
	execute(':vertical resize -25')
	execute(':split '.file_path.'.out')
endfunction
command! -nargs=+ -complete=dir CPNEW call CreateCPFiles(<f-args>)


" augroup FiletypeGroup
" 	autocmd!
" 	au BufNewFile,BufRead *.jsx set filetype=javascript.jsx
" augroup END

set t_Co=256
" let g:Powerline_symbols = "fancy"
" let g:Powerline_dividers_override = ["\Ue0b0","\Ue0b1","\Ue0b2","\Ue0b3"]
" let g:Powerline_symbols_override = {'BRANCH': "\Ue0a0", 'LINE': "\Ue0a1", 'RO': "\Ue0a2"}
" let g:airline_powerline_fonts = 1
" let g:airline_right_alt_sep = ''
" let g:airline_right_sep = ''
" let g:airline_left_alt_sep= ''
" let g:airline_left_sep = ''

" air-line
" let g:airline_powerline_fonts = 1

" if !exists('g:airline_symbols')
"     let g:airline_symbols = {}
"     endif


    " unicode symbols
 " let g:airline_left_sep = '»'
 " let g:airline_left_sep = '▶'
 " let g:airline_right_sep = '«'
 " let g:airline_right_sep = '◀'
 " let g:airline_symbols.linenr = '␊'
 " let g:airline_symbols.linenr = '␤'
 " let g:airline_symbols.linenr = '¶'
 " let g:airline_symbols.branch = '⎇'
 " let g:airline_symbols.paste = 'ρ'
 " let g:airline_symbols.paste = 'Þ'
 " let g:airline_symbols.paste = '∥'
 " let g:airline_symbols.whitespace = 'Ξ'

 " airline symbols
 " let g:airline_left_sep = ''
 " let g:airline_left_alt_sep = ''
 " let g:airline_right_sep = ''
 " let g:airline_right_alt_sep = ''
 " let g:airline_symbols.branch = ''
 " let g:airline_symbols.readonly = ''
 " let g:airline_symbols.linenr = ''

 "Airline Themes
 "let g:airline_theme='dark'
 "let g:airline_theme='badwolf'
 " let g:airline_theme='ravenpower'
 " let g:airline_theme='simple'
 " let g:airline_theme='term'
 let g:airline_theme='ubaryd'
 " let g:airline_theme='laederon'
 " let g:airline_theme='kolor'
 " let g:airline_theme='molokai'
 " let g:airline_theme='powerlineish'


" And here it ends

" set nocompatible              " be iMproved, required
" filetype off                  " required

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
" Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'luochen1990/rainbow'
Plug 'vim-ruby/vim-ruby'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-repeat'
Plug 'styled-components/vim-styled-components'
Plug 'jiangmiao/auto-pairs'
Plug 'Yggdroot/indentLine'
" set rtp+=~/.fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-bundler'
Plug 'farfanoide/inflector.vim'
" Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'thoughtbot/vim-rspec'
Plug 'christoomey/vim-tmux-navigator'
Plug 'leafgarland/typescript-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'PeterRincker/vim-argumentative'
Plug 'junegunn/vader.vim'
Plug 'puremourning/vimspector'
Plug 'turbio/bracey.vim'
Plug 'github/copilot.vim'
" Plug 'jpalardy/vim-slime', { 'for': 'python'  }
" Plug 'hanschen/vim-ipython-cell', { 'for': 'python'  }
" Plug 'bfredl/nvim-ipy', { 'for': 'python' }


" Plug 'ternjs/tern_for_vim'
Plug 'sheerun/vim-polyglot'
call plug#end()

" filetype plugin indent on    " required
" ================ Plugin Settings ===========================

"colorscheme wombat256
"colorscheme tango
"colorscheme railscasts
"colorscheme vividchalk
"colorscheme distinguished
"colorscheme monokai
"colorscheme molokai
"colorscheme ir_black
"colorscheme palenight
"colorscheme neodark
"colorscheme kolor
"colorscheme gotham
"colorscheme jellybeans
"colorscheme desertEx
colorscheme badwolf
"colorscheme gotham256
"colorscheme skittles_berry
"colorscheme skittles_dark
"colorscheme codeblocks_dark
" colorscheme gruvbox
" set background=dark
"
"
" " ================ Slime =======================
" let g:slime_target = "tmux"
" let g:slime_paste_file = "$HOME/.slime_paste"



" ================ Tmux PowerLine Setting =======================
let g:tmuxline_powerline_separators = 0



" ================ Rails Rspec =======================

let g:rspec_command = "term rspec {spec}"
map <Leader>ra :call RunCurrentSpecFile()<CR>
map <Leader>rs :call RunNearestSpec()<CR>
map <Leader>rl :call RunLastSpec()<CR>
map <Leader>rt :call RunAllSpecs()<CR>

" ================ inflector ====================
let g:inflector_mapping = 'gI'

" ================ airline =======================
let g:airline_section_b = ''

" ================ Vimspecter =======================

let g:vimspector_enable_mappings = 'HUMAN'
" packadd! vimspector

" ================ COC =======================
command! -nargs=0 Prettier :CocCommand prettier.formatFile
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
	autocmd!
	" Setup formatexpr specified filetype(s).
	autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
	" Update signature help on jump placeholder.
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" ================ COC END =======================
"
" polyglot

" ~/.vimrc, declare this variable before polyglot is loaded
let g:polyglot_disabled = ['csv']

" Rainbow
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

" Intend
let g:indentLine_color_term = 239
let g:indentLine_char = 'Ͱ'  "ǂ˧
let g:indentLine_showFirstIndentLevel = 1

" Tagbar
" nmap <silent> <leader>b :TagbarToggle<cr>

" Nerdtree
let g:NERDTreeQuitOnOpen=1
" show hidden files in NERDTree
let NERDTreeShowHidden=1
nmap <silent> <leader>k :NERDTreeToggle<cr>
nmap <silent> <leader>y :NERDTreeFind<cr>
nmap <Leader>r :NERDTreeFocus<cr>R<c-w><c-p>
" Automatically delete the buffer of file that is deleted by nerttree
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  " set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  augroup END

else

  " set autoindent		" always set autoindenting on

endif " has("autocmd")

" Quick comment toggling
noremap \ :Commentary<CR>
autocmd FileType ruby setlocal commentstring=#\ %s

" FZF Plugin Setting
" {{{
  let g:fzf_nvim_statusline = 0 " disable statusline overwriting
  " let $FZF_DEFAULT_COMMAND = "find -L -type f -not -path '*/\(.git|tmp)/*'"
  let $FZF_DEFAULT_COMMAND = 'ag -g ""'
  nnoremap <silent> <leader>t :Files<CR>
  nnoremap <silent> <leader>a :Buffers<CR>
  nnoremap <silent> <leader>A :Windows<CR>
  nnoremap <silent> <leader>; :BLines<CR>
  nnoremap <silent> <leader>o :BTags<CR>
  nnoremap <silent> <leader>O :Tags<CR>
  nnoremap <silent> <leader>? :History<CR>
  nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
  nnoremap <silent> <leader>. :AgIn

  nnoremap <silent> K :call SearchWordWithAg()<CR>
  vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
  nnoremap <silent> <leader>gl :Commits<CR>
  nnoremap <silent> <leader>ga :BCommits<CR>
  nnoremap <silent> <leader>ft :Filetypes<CR>

  imap <C-x><C-f> <plug>(fzf-complete-file-ag)
  imap <C-x><C-l> <plug>(fzf-complete-line)

	function! CopyToReg(line)
		if getbufvar(bufnr('%'), '&buftype') == 'terminal'
			call term_sendkeys(bufnr('%'), "" . a:line)
		else
			execute "norm! a" . a:line
		endif
	endfunction
	command! Scripts call fzf#run({'source': readfile('.comet/temp.rb'), 'sink': function('CopyToReg'), 'down': '40%', 'options': '--tac'})

	tnoremap <C-o> <C-\><C-n>:Scripts<CR>i

  function! SearchWordWithAg()
    execute 'Ag' expand('<cword>')
  endfunction

  function! SearchVisualSelectionWithAg() range
    let old_reg = getreg('"')
    let old_regtype = getregtype('"')
    let old_clipboard = &clipboard
    set clipboard&
    normal! ""gvy
    let selection = getreg('"')
    call setreg('"', old_reg, old_regtype)
    let &clipboard = old_clipboard
    execute 'Ag' selection
  endfunction

  function! SearchWithAgInDirectory(...)
    call fzf#vim#ag(join(a:000[1:], ' '))
  endfunction
  command! -nargs=+ -complete=dir AgIn call SearchWithAgInDirectory(<f-args>)

" }}}

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.


if has('gui')
	set guioptions-=e
endif
if exists("+showtabline")
	function MyTabLine()
		let s = ''
		let t = tabpagenr()
		let i = 1
		while i <= tabpagenr('$')
			let buflist = tabpagebuflist(i)
			let winnr = tabpagewinnr(i)
			let s .= '%' . i . 'T'
			let s .= (i == t ? '%1*' : '%2*')
			let s .= ' '
			let s .= i . ':'
			let s .= winnr . '/' . tabpagewinnr(i,'$')
			let s .= ' %*'
			let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
			let bufnr = buflist[winnr - 1]
			let file = bufname(bufnr)
			let buftype = getbufvar(bufnr, 'buftype')
			if buftype == 'nofile'
				if file =~ '\/.'
					let file = substitute(file, '.*\/\ze.', '', '')
				endif
			else
				let file = fnamemodify(file, ':p:t')
			endif
			if file == ''
				let file = '[No Name]'
			endif
			let s .= file
			let i = i + 1
		endwhile
		let s .= '%T%#TabLineFill#%='
		let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
		return s
	endfunction
	set stal=2
	set tabline=%!MyTabLine()
	map    <C-Tab>    :tabnext<CR>
	imap   <C-Tab>    <C-O>:tabnext<CR>
	map    <C-S-Tab>  :tabprev<CR>
	imap   <C-S-Tab>  <C-O>:tabprev<CR>
endif




function! CopyMatches(reg)
	let hits = []
	%s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
	let reg = empty(a:reg) ? '+' : a:reg
	execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

if has('syntax') && has('eval')
  packadd! matchit
endif
