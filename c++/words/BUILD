cc_library(
    name = "numerical_lib",
    srcs = ["src/numerical.cpp"],
    hdrs = ["include/numerical.h"],
)

cc_library(
    name = "words_lib",
    srcs = ["src/words.cpp"],
    hdrs = ["include/words.h"],
)

cc_test(
    name = "numerical_test",
    srcs = ["test/numerical_test.cpp"],
    deps = [
        ":numerical_lib",
        "@googletest//:gtest",
        "@googletest//:gtest_main",
    ],
)

cc_test(
    name = "words_test",
    srcs = ["test/words_test.cpp"],
    deps = [
        ":words_lib",
        "@googletest//:gtest",
        "@googletest//:gtest_main",
    ],
)