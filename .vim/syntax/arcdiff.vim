if exists("b:current_syntax")
    finish
endif

syntax keyword sectionKeyword Summary Reviewers Subscribers
syntax match sectionKeyword "\vTest Plan"
syntax match sectionKeyword "\Revert Plan"

highlight link sectionKeyword Keyword

syntax match diffComment "\v#.*$"
highlight link diffComment Comment

let b:current_syntax = "arcdiff"
