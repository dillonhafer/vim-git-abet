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

function! s:GitAbetInstall()
  let os = substitute(system('uname'), '\n', '', '')
  if l:os == "Darwin"
    let uri = "https://github.com/dillonhafer/git-abet/releases/download/0.0.1/git-abet-mac"
  elseif g:os == "Linux"
    let uri = "https://github.com/dillonhafer/git-abet/releases/download/0.0.1/git-abet-linux"
  endif

  execute "!curl -s -fL '".l:uri."' > /usr/local/bin/git-abed"
endfunction

command! -nargs=* GitAbet call s:GitAbetCommand(expand("%p"), "5")
command! -nargs=* GitAbetInstall call s:GitAbetInstall()

nnoremap <leader>a :call <SID>GitAbetCommand(expand("%p"), "5")<cr>

