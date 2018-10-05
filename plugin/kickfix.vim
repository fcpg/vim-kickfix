" kickfix.vim - quickfix editing

command! -nargs=1 -bar -bang QFilterName
      \ call kickfix#QFilterName(<q-args>, '<bang>'=='')
command! -nargs=1 -bar -bang LocFilterName
      \ call kickfix#LocFilterName(<q-args>, '<bang>'=='')

command! -nargs=1 -bar -bang QFilterContent
      \ call kickfix#QFilterContent(<q-args>, '<bang>'=='')
command! -nargs=1 -bar -bang LocFilterContent
      \ call kickfix#LocFilterContent(<q-args>, '<bang>'=='')

command! -bar QInfo call kickfix#QInfo()

command! -range -bar QDeleteLine
      \ call kickfix#QDeleteLine(<line1>, <line2>)

command! -bar -nargs=1 -complete=file QLoad
      \ call kickfix#QLoad(<q-args>)

