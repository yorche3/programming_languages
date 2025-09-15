recursive_tests = static_library('recursive_tests',
  ['numbers_recursive_test.vala'],
  link_with: [recursive_lib],
  dependencies: [glib_dep, recursive_dep],
  include_directories: include_directories('.'),
  vala_args: ['--pkg', 'gobject-2.0']
)

iterative_tests = static_library('iterative_tests',
  ['numbers_iterative_test.vala'],
  link_with: [iterative_lib],
  dependencies: [glib_dep, iterative_dep],
  include_directories: include_directories('.'),
  vala_args: ['--pkg', 'gobject-2.0']
)

test_exe = executable('run_tests',
  ['run_tests.vala'],
  link_with : [recursive_tests, iterative_tests],
  dependencies : [glib_dep, gobject_dep],
  include_directories : include_directories('.'),
)

test('run_tests', test_exe, depends: [recursive_tests, iterative_tests])