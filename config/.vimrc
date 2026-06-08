syntax on
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
nnoremap <Leader>\ :terminal<CR>
autocmd BufNewFile,BufFilePre,BufRead *.txt set filetype=markdown.pandoc
autocmd BufNewFile,BufRead *.hcl,*.tf set filetype=hcl
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
autocmd BufNewFile,BufFilePre,BufRead *.txt set filetype=bash
call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'hashivim/vim-terraform'
call plug#end()
