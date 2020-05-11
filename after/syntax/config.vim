" shVariable     xxx match /\<\([bwglsav]:\)\=[a-zA-Z0-9.!@_%+,]*\ze=/  nextgroup=shvarassign links to shSetList
syn match configVariable /^\<\([bwglsav]:\)\=[a-zA-Z0-9.!@_%+,]*\ze\(=\|-\).*/  nextgroup=shvarassign

hi! link configVariable shVariable
