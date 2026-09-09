const std = @import("std");

// Although this function looks imperative, it does not perform the build
// directly and instead it mutates the build graph (`b`) that will be then
// executed by an external runner. The functions in `std.Build` implement a DSL
// for defining build steps and express dependencies between them, allowing the
// build runner to parallelize the build automatically (and the cache system to
// know when a step doesn't need to be re-run).
pub fn build(b: *std.Build) void {
    // Standard target options allow the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});
    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});
    // It's also possible to define more custom flags to toggle optional features
    // of this build script using `b.option()`. All defined flags (including
    // target and optimize options) will be listed when running `zig build --help`
    // in this directory.

    // This creates a module, which represents a collection of source files alongside
    // some compilation options, such as optimization mode and linked system libraries.
    // Zig modules are the preferred way of making Zig code available to consumers.
    // addModule defines a module that we intend to make available for importing
    // to our consumers. We must give it a name because a Zig package can expose
    // multiple modules and consumers will need to be able to specify which
    // module they want to access.
    const mod_numerical =
        b.addModule("numerical", .{ .root_source_file = b.path("src/numerical.zig") });

    const mod_words =
        b.addModule("words", .{ .root_source_file = b.path("src/words.zig") });

    // Create a module for the numerical test file, and import the 'numerical' library module.
    const numerical_test_module = b.createModule(.{ .root_source_file = b.path("test/numerical_test.zig"), .imports = &.{.{ .name = "numerical", .module = mod_numerical }}, .target = target, .optimize = optimize });
    const numerical_test = b.addTest(.{ .name = "numerical_test", .root_module = numerical_test_module });

    // Create a module for the words test file, and import the 'words' library module.
    const words_test_module = b.createModule(.{ .root_source_file = b.path("test/words_test.zig"), .imports = &.{.{ .name = "words", .module = mod_words }}, .target = target, .optimize = optimize });
    const words_test = b.addTest(.{ .name = "words_test", .root_module = words_test_module });

    const run_numerical_test = b.addRunArtifact(numerical_test);
    const run_words_test = b.addRunArtifact(words_test);

    const test_step = b.step("test", "Run all tests");
    test_step.dependOn(&run_numerical_test.step);
    test_step.dependOn(&run_words_test.step);
}
