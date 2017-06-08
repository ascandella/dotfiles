#!/usr/bin/env zunit

@test 'Internal error prints output' {
  load ../.support/errors.sh

  run _internal_error "Test"
  assert "${output}" matches 'Test'
}
