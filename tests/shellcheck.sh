#!/usr/bin/env zunit

@test 'Shellcheck install.sh' {
  load ../.test-helpers/shellcheck
  _test_shellcheck install.sh bash
}

@test 'Shellcheck cleanup.sh' {
  load ../.test-helpers/shellcheck
  _test_shellcheck cleanup.sh
}
