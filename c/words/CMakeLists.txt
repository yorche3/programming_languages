add_custom_target(run_all
    COMMAND ${CMAKE_COMMAND} -E echo "Building the project using ninja..."
    COMMAND ninja -C build
    COMMAND ${CMAKE_COMMAND} -E echo "Running tests..."
    COMMAND ./build/test/run_tests
    COMMAND ${CMAKE_COMMAND} -E echo "Cleaning up build artifacts..."
    COMMAND ${CMAKE_COMMAND} -E remove_directory build
)