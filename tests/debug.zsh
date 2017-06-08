#!/usr/bin/env zunit

@setup {
  load ../.support/functions.sh
}

@test 'Debug ignores output when env not set' {
  run _debug "foo"
  assert "${output}" is_empty
}
