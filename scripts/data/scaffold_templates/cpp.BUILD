cc_library(
    name = "@MODULE@_lib",
    srcs = ["src/@MODULE@.cpp"],
    hdrs = ["include/@MODULE@.h"],
    strip_include_prefix = "include",
    visibility = ["//visibility:public"],
)

cc_test(
    name = "@MODULE@_tests",
    size = "small",
    srcs = ["tests/@MODULE@_test.cpp"],
    deps = [
        ":@MODULE@_lib",
        "@com_google_googletest//:gtest_main",
    ],
)
