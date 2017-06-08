#!/usr/bin/env zunit

@setup {
  dir="$(mktemp -d)"
  THISDIR=${dir}

  load ../.support/cleanup.sh
  load ../.support/errors.sh

  cd ${dir}
}

@teardown {
  rm -rf ${dir}
}

@test 'Cleanup symlink requires argument' {
  run _maybeCleanupSymlink
  assert "${output}" matches "without argument"
}

@test 'Cleanup leaves valid symlink alone' {
  touch foo
  ln -s ${dir}/foo bar
  run _maybeCleanupSymlink ${dir}/bar

  assert ${dir}/bar is_link
}

@test 'Cleanup removes bad symlinks' {
  ln -s ${dir}/baz bar

  run _maybeCleanupSymlink ${dir}/bar
  assert "${output}" matches "bad link"
}
