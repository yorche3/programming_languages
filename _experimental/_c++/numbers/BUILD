cc_library(
    name = "numbers_recursive_lib",
    srcs = ["src/implementations/numbers_recursive.cpp"],
    hdrs = ["src/interfaces/numbers_recursive.h"],
)

cc_library(
    name = "numbers_iterative_lib",
    srcs = ["src/implementations/numbers_iterative.cpp"],
    hdrs = ["src/interfaces/numbers_iterative.h"],
)

cc_test(
    name = "numbers_recursive_test",
    srcs = ["test/numbers_recursive_test.cpp"],
    deps = [
        ":numbers_recursive_lib",
        "@googletest//:gtest",
        "@googletest//:gtest_main",
    ],
)

cc_test(
    name = "numbers_iterative_test",
    srcs = ["test/numbers_iterative_test.cpp"],
    deps = [
        ":numbers_iterative_lib",
        "@googletest//:gtest",
        "@googletest//:gtest_main",
    ],
)