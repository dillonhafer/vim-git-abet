function! s:GitAbetCommand(path, number)
  call s:EchoProgress("searching commits...")

  let g:gitAbetPrivateBackgroundCommandOutput = tempname()
  let cmd = "git-abet -n ".a:number." ".a:path

  call job_start(l:cmd, {
    \'close_cb': 'CloseAbetHandler',
    \'err_name': g:gitAbetPrivateBackgroundCommandOutput,
    \'err_io': 'file'
    \})
endfunction

function! CloseAbetHandler(channel)
  echom ""
  set makeprg=%p
  set errorformat=%f

  execute "cfile! ".g:gitAbetPrivateBackgroundCommandOutput
  copen
  unlet g:gitAbetPrivateBackgroundCommandOutput
endfunction

function! s:EchoProgress(msg)
  redraw | echohl Identifier | echom "vim-git-abet: " . a:msg | echohl None
endfunction

command! -nargs=* GitAbet call s:GitAbetCommand(expand("%p"), "5")
nnoremap <leader>a :call <SID>GitAbetCommand(expand("%p"), "5")<cr>

