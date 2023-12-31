set expandtab " insert space characters when pressing tab
set shiftwidth=4 " make each indentation equal to 4 spaces
set tabstop=4 " make size of a tab character equal to 4 spaces
set softtabstop=4 " deletes indents in groups when pressing backspace
" make vim respect XDG folders
set directory=$XDG_CACHE_HOME/vim,~/,/tmp
set backupdir=$XDG_CACHE_HOME/vim,~/,/tmp
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo
syntax on
