Vim-Kickfix
------------

> _Kick it till it's fixed._

Kickfix lets you filter, discard and save entries from the quickfix list.

It's a simple, crude but reasonably effective tool to shape the quickfix as
you like, discarding unwanted matches and possibly saving it once you're done.

[![asciicast](https://asciinema.org/a/iIfNKV7cK1UqdBnSAhoZksNLe.png)](https://asciinema.org/a/iIfNKV7cK1UqdBnSAhoZksNLe)

Usage
------
Entries can be deleted with the `d` normal command in the quickfix window; the
quickfix list is updated accordingly.

Other commands:

*:[range]QDeleteLine*
Delete current line, or lines in range.

*:QFilterName[!] {pattern}*
Keep only filenames matching pattern. Discard them if [!].

*:QFilterContent[!] {pattern}*
Keep only files whose content matches pattern. Discard them if [!].

*:QInfo*
Show number of files and number of entries in the quickfix list.

*:QLoad {path}*
Load quickfix from path. Quickfix content can be saved as is with `:w {path}`.

Mappings:

*<Plug>(KickfixPreview)*
Open quickfix entry in preview window. Buffer-local.

Options:

*g:kickfix_zebra*
Set to zero to disable zebra highlighting in quickfix window.

Configuration Example:

```
(in .vim/after/ftplugin/qf.vim):

  nmap <silent><buffer>  p  <Plug>(KickfixPreview)
  nmap <silent><buffer>  <C-g>  :<C-u>QInfo<cr>

(in .vim/vimrc):

  hi link qfFileName1 Statement
  hi link qfFileName2 PreProc
```

Installation
-------------
Use your favorite method:
*  [Pathogen][1] - git clone https://github.com/fcpg/vim-kickfix ~/.vim/bundle/vim-kickfix
*  [NeoBundle][2] - NeoBundle 'fcpg/vim-kickfix'
*  [Vundle][3] - Plugin 'fcpg/vim-kickfix'
*  [Plug][4] - Plug 'fcpg/vim-kickfix'
*  manual - copy all files into your ~/.vim directory

Pluginophobia
--------------

If you don't like plugins, feel free to steal snippets into your vimrc.

License
--------
[Attribution-ShareAlike 4.0 Int.](https://creativecommons.org/licenses/by-sa/4.0/)

[1]: https://github.com/tpope/vim-pathogen
[2]: https://github.com/Shougo/neobundle.vim
[3]: https://github.com/gmarik/vundle
[4]: https://github.com/junegunn/vim-plug
