add_custom_target(run_tests
    COMMAND bash -c "echo 'Starting Tests...'; bazel test //:all; if [ $$? -ne 0 ]; then echo 'Tests failed!'; exit 1; fi"
)

add_custom_target(clean_project
    COMMAND bash -c "echo 'Cleaning project...'; rm -rf bazel*; rm -f MODULE.bazel.lock; echo 'Cleanup completed.'"
)