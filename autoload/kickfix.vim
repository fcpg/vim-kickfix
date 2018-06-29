" kickfix functions
let s:save_cpo = &cpo
set cpo&vim


" Preview {{{1
" open the current entry in the preview window
function kickfix#Preview() abort
  let curline = getline(line('.'))
  let curfile = fnameescape(matchstr(curline, '^[^|]\+'))
  let curpos  = curline =~ '|\d\+'
                \ ? "+".matchstr(curline, '|\zs\d\+')
                \ : ""
  exe "pedit" curpos curfile
endfun

" QFilterName {{{1
" Filter in/out quickfix entries by filename
function! kickfix#QFilterName(rx, filter_in) abort
  let nqf = []
  let g:oldqf = getqflist()
  let [kept, removed, nobuf] = [0, 0, 0]
  for f in g:oldqf
    if !get(f, 'bufnr', 0)
      let nobuf += 1
      continue
    endif
    let bufname = bufname(f.bufnr)
    if (a:filter_in && match(bufname, a:rx) != -1)
          \ || (!a:filter_in && match(bufname, a:rx) == -1)
      call add(nqf, copy(f))
      let kept += 1
    else
      let removed += 1
    endif
  endfor
  echom printf('Removed: %d, Kept: %d, Nobuf: %d', removed, kept, nobuf)
  call setqflist(nqf)
endfun

" QFilterContent {{{1
" Filter in/out quickfix entries by content
function! kickfix#QFilterContent(rx, filter_in) abort
  let nqf = []
  let g:oldqf = getqflist()
  let [kept, removed, nobuf] = [0, 0, 0]
  for f in g:oldqf
    if !get(f, 'bufnr', 0)
      let nobuf += 1
      continue
    endif
    exe 'b' f.bufnr
    if (a:filter_in && search(a:rx, 'wn'))
          \ || (!a:filter_in && !search(a:rx, 'wn'))
      call add(nqf, copy(f))
      let kept += 1
    else
      let removed += 1
    endif
  endfor
  echom printf('Removed: %d, Kept: %d, Nobuf: %d', removed, kept, nobuf)
  call setqflist(nqf)
endfun

" QDeleteLine {{{1
" Remove line(s) from quickfix
function! kickfix#QDeleteLine(...) abort
  if a:0 == 1 && type(a:1) == type("")
    " called from g@
    let [l1, l2] = [line("'["), line("']")]
  elseif a:0 == 2
    " called from cmdline
    let [l1, l2] = [a:1, a:2]
  else
    echom "Argument error (kickfix#QDeleteLine)"
    return
  endif
  let curline = line('.')
  let g:oldqf = getqflist()
  let nqf = copy(g:oldqf)
  call remove(nqf, l1 - 1, l2 - 1)
  call setqflist(nqf)
  call cursor(curline, 0)
endfun

" QLoad {{{1
" Load saved quickfix buffer
function! kickfix#QLoad(file) abort
  let oldefm = &efm
  setlocal efm+=%f\|%l\ col\ %c\|%m
  exe "cfile" a:file
  let &efm = oldefm
endfun


let &cpo = s:save_cpo
