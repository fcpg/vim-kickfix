" kickfix.vim - quickfix editing

command! -nargs=1 -bar -bang QFilterName
      \ call kickfix#QFilterName(<q-args>, '<bang>'=='')

command! -nargs=1 -bar -bang QFilterContent
      \ call kickfix#QFilterContent(<q-args>, '<bang>'=='')

command! -bar QInfo
      \ echo printf("%d File(s), %d Line(s)",
      \   len(eval('{'.
      \     join(uniq(map(getqflist(),'v:val.bufnr'),'N'),':1,').
      \     ':1}')),
      \   len(getqflist()))

command! -range -bar QDeleteLine
      \ call kickfix#QDeleteLine(<line1>, <line2>)

command! -bar -nargs=1 -complete=file QLoad
      \ call kickfix#QLoad(<q-args>)

