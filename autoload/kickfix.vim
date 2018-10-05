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
function! s:FilterName(list, rx, filter_in) abort
  let newlist = []
  let oldlist = a:list
  let [kept, removed, nobuf] = [0, 0, 0]
  for f in oldlist
    if !get(f, 'bufnr', 0)
      let nobuf += 1
      continue
    endif
    let bufname = bufname(f.bufnr)
    if (a:filter_in && match(bufname, a:rx) != -1)
          \ || (!a:filter_in && match(bufname, a:rx) == -1)
      call add(newlist, copy(f))
      let kept += 1
    else
      let removed += 1
    endif
  endfor
  echom printf('Removed: %d, Kept: %d, Nobuf: %d', removed, kept, nobuf)
  return newlist
endfunction

function! kickfix#QFilterName(rx, filter_in) abort
  call setqflist(s:FilterName(getqflist(), a:rx, a:filter_in))
endfun

function! kickfix#LocFilterName(rx, filter_in) abort
  call setloclist(0, s:FilterName(getloclist(0), a:rx, a:filter_in))
endfunction

" QFilterContent {{{1
" Filter in/out quickfix entries by content
function! s:FilterContent(list, rx, filter_in) abort
  let newlist = []
  let oldlist = a:list
  let [kept, removed, nobuf] = [0, 0, 0]
  let winid = win_getid()
  1split
  for f in oldlist
    if !get(f, 'bufnr', 0)
      let nobuf += 1
      continue
    endif
    exe 'noauto b' f.bufnr
    if (a:filter_in && search(a:rx, 'wn'))
          \ || (!a:filter_in && !search(a:rx, 'wn'))
      call add(newlist, copy(f))
      let kept += 1
    else
      let removed += 1
    endif
  endfor
  echom printf('Removed: %d, Kept: %d, Nobuf: %d', removed, kept, nobuf)
  close
  if win_id2win(winid)
    call win_gotoid(winid)
  endif
  return newlist
endfunction

function! kickfix#QFilterContent(rx, filter_in) abort
  call setqflist(s:FilterContent(getqflist(), a:rx, a:filter_in))
endfun

function! kickfix#LocFilterContent(rx, filter_in) abort
  call setloclist(0, s:FilterContent(getloclist(0), a:rx, a:filter_in))
endfunction

" QInfo {{{1
" Print number of files and number of errors in the quickfix
function! kickfix#QInfo() abort
  let curlist = !empty(getloclist(0)) ? getloclist(0) : getqflist()
  let files = empty(curlist)
        \ ? {}
        \ : eval('{'.
        \ join(uniq(map(copy(curlist),'v:val.bufnr'),'N'),':1,').
        \ ':1}')

  echo printf("%d File(s), %d Line(s)", len(files), len(curlist))
endfunction

" QDeleteLine {{{1
" Remove line(s) from quickfix
function! kickfix#QDeleteLine(...) abort
  let isloc = !empty(getloclist(0))
  let curlist = isloc ? getloclist(0) : getqflist()
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
  let newlist = copy(curlist)
  call remove(newlist, l1 - 1, l2 - 1)
  if isloc
    call setloclist(0, newlist)
  else
    call setqflist(newlist)
  endif
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

" FoldText {{{1
" Function for 'foldtext in quickfix
function! kickfix#FoldText() abort
  let numlines = v:foldend - v:foldstart + 1
  let filename = matchstr(getline(v:foldstart), '[^|]*')
  let filelen  = strchars(filename)

  if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8') && version >= 700
    let myfoldchar = '─'
  else
    let myfoldchar = '-'
  endif

  let spacer_left  = repeat(myfoldchar, 4)
  let spacer_mid   = repeat(myfoldchar, 5)
  let spacer_right = repeat(myfoldchar, 4)

  if filelen > 50
    " extract the last path components so that total length < 47
    let filename_end = strcharpart(filename, filelen - 47)
    let ssl = exists('+shellslash') ? &shellslash : '/'
    let filename_upto50 = "..." . matchstr(filename_end, ssl.'.*') 
  else
    let filename_upto50 = filename
  endif

  let txt = printf("+%s %-50.50s %s (%4d lines) %s",
        \ spacer_left, filename_upto50, spacer_mid, numlines, spacer_right)
  return txt
endfun

let &cpo = s:save_cpo
