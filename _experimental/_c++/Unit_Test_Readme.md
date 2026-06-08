
# Unit Test projects with bazel and C++ with GoogleTest
How were built unit test projects.

## Requisites
- Install
  - [g++](https://gcc.gnu.org/)
  - [bazel](https://bazel.build/)

## Structure
```text
demo
|--- src
|    |--- implementations
|    |--- interfaces
|--- test
|--- BUILD
|--- MODULE.bazel
```

## Configure
Go to `demo` directory and
- Modify `MODULE.bazel` file similar to following:
```bazel
# MODULE.bazel (preferred for newer Bazel versions)
bazel_dep(name = "googletest", version = "1.15.2") # Use the desired version

# WORKSPACE (for older Bazel versions)
# load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
# http_archive(
#     name = "com_google_googletest",
#     sha256 = "...", # Replace with the correct SHA256 for your chosen version
#     strip_prefix = "googletest-...", # Adjust prefix based on the archive
#     urls = ["https://github.com/google/googletest/archive/refs/tags/release-1.15.2.tar.gz"], # Use the correct URL
# )
```

## Build project
```bash
```

## Modify project
- For each `"lib"` `example.cpp` add a `example_test` in `BUILD` similar to the following:
```
cc_library(
    name = "example1_lib",
    srcs = ["src/implementations/example1.cpp"],
    hdrs = ["src/interfaces/example1.h"],
)
cc_test(
    name = "example1_test",
    srcs = ["test/example1_test.cpp"],
    deps = [
        ":example1_lib",
        "@googletest//:gtest",
        "@googletest//:gtest_main",
    ],
)
```
## Compile and run tests
```bash
bazel test //:all
```