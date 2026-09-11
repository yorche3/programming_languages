# Build recursive tests library
recursive_tests_lib = static_library('recursive_tests',
  ['suites/test_numbers_recursive.c'],
  include_directories : include_directories('.'),
)

# Build iterative tests library
iterative_tests_lib = static_library('iterative_tests',
  ['suites/test_numbers_iterative.c'],
  include_directories : include_directories('.'),
)

# Create an executable for tests
test_exe = executable('run_tests',
  ['run_tests.c'],
  link_with : [recursive_lib, iterative_lib, recursive_tests_lib, iterative_tests_lib],
  dependencies : check_dep,
  include_directories : include_directories('.'),
)