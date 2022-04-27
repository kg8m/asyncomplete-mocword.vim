asyncomplete-mocword.vim
==================================================

Provides intelligent English autocomplete for asyncomplete.vim via mocword.


Screenshot
--------------------------------------------------

FIXME


Installing
--------------------------------------------------

```
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'kg8m/asyncomplete-mocword.vim'
```

You also need to install [Mocword](https://github.com/high-moctane/mocword) and [Mocword-data](https://github.com/high-moctane/mocword-data).


### Registration

```vim
call asyncomplete#register_source(asyncomplete#sources#mocword#get_source_options({
\   "name": "mocword",
\   "allowlist": ["*"],
\   "args": ["-l", "100"],
\   "completor": function("asyncomplete#sources#mocword#completor")
\ }))
```

Note: `args` is optional. it will be passed as the `mocword` arguments.
