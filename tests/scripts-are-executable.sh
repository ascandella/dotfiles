#!/usr/bin/env zunit

@test 'Root scripts are executable' {
  load ../.test-helpers/executable

  _assert_executable *.sh
}
