#!/usr/bin/env zunit

@test 'Shellcheck' {
  run shellcheck ./install.sh
  assert $state equals 0
  assert $output is_empty
}
