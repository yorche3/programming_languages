
# Unit Test projects with Meson + Ninja and C with Check
How were built unit test projects.

## Requisites
- Install
  - GCC
  - [Meson](https://github.com/mesonbuild/meson)
  - [Ninja](https://github.com/ninja-build/ninja)
  - [Check](https://libcheck.github.io/check/index.html)

## Structure
```text
demo
|--- src
|    |--- implementations (directory for files.c)
|    |--- interfaces (directory for files.h)
|    |--- meson.build
|--- test
|    |--- suites (directory for tests.c)
|    |--- run_tests.c
|    |--- meson.build
|--- meson.build
```

## Configure
Go to `demo` directory and
- modify `meson.build` file similar to following:
```meson
project('demo', 'c')

check_dep = dependency('check')

subdir('src')
subdir('test')
```

- In `src/meson.build` for each `lib` add:
```meson
# Build example lib
example_lib = static_library('example',
  ['implementations/example.c'],
  include_directories : include_directories('.'),
)
```

## Build project
```bash
meson setup build
```

## Modify project
- For each `"lib"` `example.c` add a `test_example.c` in `test/suites` dir similar to the following:
```c
#include <check.h>
#include "../../src/interfaces/example.h"

START_TEST(test_function1) {
    ck_assert_int_eq(function1(X), expected);
}

START_TEST(test_function2) {
    ck_assert_int_eq(function2(X), expected);
}

Suite* example_suite(void) {
    Suite *s = suite_create("Example Test");
    TCase *tc = tcase_create("Core");
    tcase_add_test(tc, test_function1);
    tcase_add_test(tc, test_function2);
    suite_add_tcase(s, tc);
    return s;
}
```
- Adecuate the `run_test` for your suites:
```c
#include <check.h>
#include <stdio.h>

extern Suite* example_suite1(void);
extern Suite* example_suite2(void);

int main() {
    int failed;
    SRunner *sr;

    // Run suite1
    sr = srunner_create(example_suite1());
    srunner_run_all(sr, CK_NORMAL);
    failed = srunner_ntests_failed(sr);
    srunner_free(sr);

    // Run suite2
    sr = srunner_create(example_suite1());
    srunner_run_all(sr, CK_NORMAL);
    failed += srunner_ntests_failed(sr);
    srunner_free(sr);

    return failed ? 1 : 0;
}
```
- Modify your `test/meson.build` file linking the tests to your `"libs"`:
```meson
# Build example1_tests library
example1_tests_lib = static_library('example1_tests',
  ['suites/test_example1.c'],
  include_directories : include_directories('.'),
)

# Build example2_tests library
example2_tests_lib = static_library('example2_tests',
  ['suites/test_example2.c'],
  include_directories : include_directories('.'),
)

# Create an executable for tests
test_exe = executable('run_tests',
  ['run_tests.c'],
  link_with : [example1_lib, example2_lib, example1_tests_lib, example2_tests_lib],
  dependencies : check_dep,
  include_directories : include_directories('.'),
)
```

## Compile and run tests
### Compile
```bash
ninja -C build
```
### Run
```bash
./build/test/run_tests
```