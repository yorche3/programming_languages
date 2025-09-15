const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod_recursive = b.addModule("numbers_recursive", .{ .root_source_file = b.path("src/numbers_recursive.zig") });

    const mod_iterative = b.addModule("numbers_iterative", .{ .root_source_file = b.path("src/numbers_iterative.zig") });

    const recursive_test = b.addTest(.{ .name = "recursive_test", .root_module = b.createModule(.{ .root_source_file = b.path("test/numbers_recursive_test.zig"), .imports = &.{.{ .name = "numbers_recursive", .module = mod_recursive }}, .target = target, .optimize = optimize }) });

    const iterative_test = b.addTest(.{ .name = "iterative_test", .root_module = b.createModule(.{ .root_source_file = b.path("test/numbers_iterative_test.zig"), .imports = &.{.{ .name = "numbers_iterative", .module = mod_iterative }}, .target = target, .optimize = optimize }) });

    b.installArtifact(recursive_test);
    b.installArtifact(iterative_test);

    _ = b.addRunArtifact(recursive_test);
    _ = b.addRunArtifact(iterative_test);
}
