" qf filetype - kickfix extensions

let b:undo_ftplugin = "setl number< nowrap<"
setl number nowrap

nnoremap <buffer><silent> dd :QDeleteLine<cr>
nnoremap <buffer><silent> d  :set opfunc=kickfix#QDeleteLine<cr>g@
xnoremap <buffer><silent> d  :QDeleteLine<cr>

nnoremap <buffer><silent> <Plug>(KickfixPreview)
      \ :<C-u>call kickfix#Preview()<cr>
