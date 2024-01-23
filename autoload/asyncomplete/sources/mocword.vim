augroup asyncomplete#sources#mocword#augroup
  autocmd!
  autocmd VimLeave * call s:stop_mocword()
augroup END

function! asyncomplete#sources#mocword#get_source_options(opt) abort
  let l:opt = copy(a:opt)

  if !has_key(opt, "args")
    let opt["args"] = ["--limit", "100"]
  endif

  if !exists("s:mocword_job")
    let s:mocword_job = asyncomplete#mocword#job#start(["mocword"] + opt["args"], { "on_stdout": function("s:on_event") })

    if s:mocword_job <= 0
      echoerr "mocword launch failed"
    endif

    let s:ctx = {}
  endif

  return opt
endfunction

function! asyncomplete#sources#mocword#completor(opt, ctx) abort
  if s:mocword_job <= 0
    return
  endif

  let l:typed = s:get_typed_string(a:ctx)
  let s:ctx = a:ctx
  let s:opt = a:opt

  call asyncomplete#mocword#job#send(s:mocword_job, l:typed . "\n")
endfunction

function! s:get_typed_string(ctx)
  let l:first_lnum = max([1, a:ctx["lnum"] - 4])
  let l:cur_lnum = a:ctx["lnum"]

  let l:lines = []
  for l:lnum in range(l:first_lnum, l:cur_lnum)
    call add(l:lines, getline(l:lnum))
  endfor

  return join(l:lines, " ")
endfunction

function! s:on_event(job_id, data, event)
  if a:event != "stdout" || !has_key(s:ctx, "typed")
    return
  endif

  let l:startcol = strridx(s:ctx["typed"], " ") + 2
  let l:candidates = split(a:data[0], " ")
  let l:items = s:generate_items(l:candidates)

  call asyncomplete#complete(s:opt["name"], s:ctx, l:startcol, l:items, 1)
endfunction

function! s:generate_items(candidates)
  return map(a:candidates, '{ "word": v:val, "menu": "[mocword]" }')
endfunction

function! s:stop_mocword()
  if exists("s:mocword_job") && s:mocword_job > 0
    call asyncomplete#mocword#job#stop(s:mocword_job)
  endif
endfunction

