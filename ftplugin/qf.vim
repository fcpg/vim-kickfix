" qf filetype - kickfix extensions

let b:undo_ftplugin = "setl number< nowrap< foldenable<"
setl number nowrap
setl foldtext=kickfix#FoldText()
setl foldmethod=syntax nofoldenable

nnoremap <buffer><silent> dd :QDeleteLine<cr>
nnoremap <buffer><silent> d  :set opfunc=kickfix#QDeleteLine<cr>g@
xnoremap <buffer><silent> d  :QDeleteLine<cr>

nnoremap <buffer><silent> <Plug>(KickfixPreview)
      \ :<C-u>call kickfix#Preview()<cr>
