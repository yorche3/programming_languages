numerical_tests = static_library('numerical_tests',
  ['numerical_test.vala'],
  link_with: [numerical_lib],
  dependencies: [glib_dep, numerical_dep],
  include_directories: include_directories('.'),
  vala_args: ['--pkg', 'gobject-2.0']
)

words_tests = static_library('words_tests',
  ['words_test.vala'],
  link_with: [words_lib],
  dependencies: [glib_dep, words_dep],
  include_directories: include_directories('.'),
  vala_args: ['--pkg', 'gobject-2.0']
)

test_exe = executable('run_tests',
  ['run_tests.vala'],
  link_with : [numerical_tests, words_tests],
  dependencies : [glib_dep, gobject_dep],
  include_directories : include_directories('.'),
)

test('run_tests', test_exe, depends: [numerical_tests, words_tests])