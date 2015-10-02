" General {
    set background=dark         " Assume a dark background
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0]) 
" }

" Vim UI {
	set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode
    set cursorline                  " Highlight current line

    if has('statusline')
        set laststatus=2

        " Broken down into easily includable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=%{fugitive#statusline()} " Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor

    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Formatting {
    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    autocmd BufNewFile,BufRead *.coffee set filetype=coffee
" }

" Key (re)Mappings {
    " The default leader is '\', but many people prefer ',' as it's in a standard
    let mapleader = ','

    " Easier moving in tabs and windows
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " Fix common typos on commands
    command! -bang -nargs=* -complete=file E e<bang> <args>
    command! -bang -nargs=* -complete=file W w<bang> <args>
    command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    command! -bang -nargs=* -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier formatting
    nnoremap <silent> <leader>q gwip
" }

" Plugins {
	" Setup Bundle Support {
	    " The next three lines ensure that the ~/.dvim/.vim/bundle/ system works
	    filetype off
	    set rtp+=~/.dvim/.vim/bundle/vundle
	    call vundle#rc()
    " }

    " Deps {
        Plugin 'gmarik/vundle'
        Plugin 'MarcWeber/vim-addon-mw-utils'
        Plugin 'tomtom/tlib_vim'
        if executable('ag')
            Plugin 'mileszs/ack.vim'
            let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
        elseif executable('ack-grep')
            let g:ackprg="ack-grep -H --nocolor --nogroup --column"
            Plugin 'mileszs/ack.vim'
        elseif executable('ack')
            Plugin 'mileszs/ack.vim'
        endif
    " }

	" Plugin List {
		" General {
			Plugin 'scrooloose/nerdtree'
            Plugin 'altercation/vim-colors-solarized'
            Plugin 'spf13/vim-colors'
            Plugin 'tpope/vim-surround'
            Plugin 'tpope/vim-repeat'
            Plugin 'jiangmiao/auto-pairs'
            Plugin 'ctrlpvim/ctrlp.vim'
            Plugin 'kristijanhusak/vim-multiple-cursors'
            Plugin 'matchit.zip'
            if (has("python") || has("python3"))
                Plugin 'Lokaltog/powerline', {'rtp':'/powerline/bindings/vim'}
            else
                Plugin 'bling/vim-airline'
            endif
            Plugin 'powerline/fonts'
            Plugin 'bling/vim-bufferline'
            Plugin 'Lokaltog/vim-easymotion'
            Plugin 'jistr/vim-nerdtree-tabs'
            Plugin 'flazz/vim-colorschemes'
            Plugin 'mbbill/undotree'
            Plugin 'nathanaelkane/vim-indent-guides'
        " }

        " General Programming {
	        Plugin 'scrooloose/syntastic'
	        Plugin 'tpope/vim-fugitive'
	        Plugin 'scrooloose/nerdcommenter'
	        Plugin 'tpope/vim-commentary'
	        Plugin 'godlygeek/tabular'
            Plugin 'editorconfig/editorconfig-vim'
    	" }

    	" Javascript {
            Plugin 'elzr/vim-json'
            Plugin 'groenewege/vim-less'
            Plugin 'pangloss/vim-javascript'
            Plugin 'briancollins/vim-jst'
            Plugin 'kchmck/vim-coffee-script'
    	" }
	    " HTML {
            Plugin 'amirh/HTML-AutoCloseTag'
            Plugin 'hail2u/vim-css3-syntax'
            Plugin 'gorodinskiy/vim-coloresque'
	    " }

	    " Ruby {
            Plugin 'tpope/vim-rails'
            let g:rubycomplete_buffer_loading = 1
            Plugin 'thoughtbot/vim-rspec'
	    " }

	    " Elixir {
	        Plugin 'elixir-lang/vim-elixir'
	        Plugin 'carlosgaldino/elixir-snippets'
	        Plugin 'mattreduce/vim-mix'
    	" }

		" Misc {
            Plugin 'tpope/vim-markdown'
            Plugin 'spf13/vim-preview'
            Plugin 'tpope/vim-cucumber'
            Plugin 'quentindecock/vim-cucumber-align-pipes'
    	" }

	" }

    " Config {

    	" NerdTree {
            map <C-e> <plug>NERDTreeTabsToggle<CR>
            map <leader>e :NERDTreeFind<CR>
            nmap <leader>nt :NERDTreeFind<CR>

            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1
            let g:nerdtree_tabs_open_on_gui_startup=0
            let g:NERDShutUp=1
    	" }

    	" Tabularize {
            nmap <Leader>a& :Tabularize /&<CR>
            vmap <Leader>a& :Tabularize /&<CR>
            nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            nmap <Leader>a=> :Tabularize /=><CR>
            vmap <Leader>a=> :Tabularize /=><CR>
            nmap <Leader>a: :Tabularize /:<CR>
            vmap <Leader>a: :Tabularize /:<CR>
            nmap <Leader>a:: :Tabularize /:\zs<CR>
            vmap <Leader>a:: :Tabularize /:\zs<CR>
            nmap <Leader>a, :Tabularize /,<CR>
            vmap <Leader>a, :Tabularize /,<CR>
            nmap <Leader>a,, :Tabularize /,\zs<CR>
            vmap <Leader>a,, :Tabularize /,\zs<CR>
            nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
            vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
        " }

        " JSON {
            nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
            let g:vim_json_syntax_conceal = 0
        " }

        " ctrlp {
            let g:ctrlp_working_path_mode = 'ra'
            nnoremap <silent> <D-t> :CtrlP<CR>
            nnoremap <silent> <D-r> :CtrlPMRU<CR>
            let g:ctrlp_custom_ignore = {'dir':  '\.git$\|\.hg$\|\.svn$', 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

            if executable('ag')
                let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
            elseif executable('ack-grep')
                let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
            elseif executable('ack')
                let s:ctrlp_fallback = 'ack %s --nocolor -f'
            else
                let s:ctrlp_fallback = 'find %s -type f'
            endif
            if exists("g:ctrlp_user_command")
                unlet g:ctrlp_user_command
            endif
            let g:ctrlp_user_command = {'types': { 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'], 2: ['.hg', 'hg --cwd %s locate -I .'] }, 'fallback': s:ctrlp_fallback }
        "}

         " Fugitive {
            nnoremap <silent> <leader>gs :Gstatus<CR>
            nnoremap <silent> <leader>gd :Gdiff<CR>
            nnoremap <silent> <leader>gc :Gcommit<CR>
            nnoremap <silent> <leader>gb :Gblame<CR>
            nnoremap <silent> <leader>gl :Glog<CR>
            nnoremap <silent> <leader>gp :Git push<CR>
            nnoremap <silent> <leader>gr :Gread<CR>
            nnoremap <silent> <leader>gw :Gwrite<CR>
            nnoremap <silent> <leader>ge :Gedit<CR>
            " Mnemonic _i_nteractive
            nnoremap <silent> <leader>gi :Git add -p %<CR>
            nnoremap <silent> <leader>gg :SignifyToggle<CR>
        "}

        " vim-airline {
            " Set configuration options for the statusline plugin vim-airline.
            " Use the powerline theme and optionally enable powerline symbols.
            " To use the symbols , , , , , , and .in the statusline
            " segments add the following to your .vimrc.before.local file:
            "   let g:airline_powerline_fonts=1
            " If the previous symbols do not render for you then install a
            " powerline enabled font.

            let g:airline#extensions#tabline#enabled = 1
            let g:airline_theme = 'solarized'
            if !exists('g:airline_powerline_fonts')
                " Use the default set of separators with a few customizations
                let g:airline_left_sep='›'  " Slightly fancier than '>'
                let g:airline_right_sep='‹' " Slightly fancier than '<'
            endif
        " }

        " RSpec {
        	" RSpec.vim mappings
    		map <Leader>t :call RunCurrentSpecFile()<CR>
    		map <Leader>s :call RunNearestSpec()<CR>
    		map <Leader>l :call RunLastSpec()<CR>
    		map <Leader>a :call RunAllSpecs()<CR>
       	" }

        " Syntastic {
            let g:syntastic_ruby_checkers = ['rubocop'] 
        " }

        " EditorConfig {
            let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
        " }
    " }
" }