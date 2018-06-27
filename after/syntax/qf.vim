" Extra qf syntax

if !get(g:, 'kickfix_zebra', 1)
  finish
endif

syn sync fromstart

syn match  qfFileName1  /^[^|]*/ nextgroup=qfSeparator contained
syn match  qfFileName2  /^[^|]*/ nextgroup=qfSeparator contained

syn match  qfZebraLineNr  /|[^|]*|/ contains=qfSeparator,qfLineNr,qfError contained nextgroup=qfSkip
syn match  qfSkip /.*$/ excludenl contains=NONE transparent

syn region  qfZebra1  matchgroup=qfZebraStart1 start=/^\z([^|]\+\)/ end=/\n\(\z1|\)\@!/ nextgroup=qfZebra2 skipnl keepend contains=qfFileName1,qfZebraLineNr
syn region  qfZebra2  matchgroup=qfZebraStart2 start=/^\z([^|]\+\)/ end=/\n\(\z1|\)\@!/ nextgroup=qfZebra1 skipnl keepend contains=qfFileName2,qfZebraLineNr


hi def qfZebra1 guibg=#222222 ctermbg=240
hi def qfZebra2 guibg=#444444 ctermbg=244

hi def link qfFileName1 qfZebra1
hi def link qfFileName2 qfZebra2

hi def link qfZebraStart1 qfFileName1
hi def link qfZebraStart2 qfFileName2

