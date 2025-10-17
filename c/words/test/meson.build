# Build numerical test library
numerical_test_lib = static_library('numerical_test',
  ['numerical_test.c'],
  include_directories : include_directories('.'),
)

# Build words test library
words_test_lib = static_library('words_test',
  ['words_test.c'],
  include_directories : include_directories('.'),
)

# Create an executable for tests
test_exe = executable('run_tests',
  ['run_tests.c'],
  link_with : [numerical_lib, words_lib, numerical_test_lib, words_test_lib],
  dependencies : check_dep,
  include_directories : include_directories('.'),
)