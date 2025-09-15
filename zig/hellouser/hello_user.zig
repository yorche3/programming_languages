const std = @import("std");

pub fn main() !void {
    const stdout = std.fs.File.stdout().deprecatedWriter();
    var bufferInput: [64]u8 = undefined;
    var stdin = std.fs.File.stdin().reader(&bufferInput);
    // Prompt the user
    try stdout.writeAll("Enter your name: ");

    const line = try stdin.interface.peekDelimiterInclusive('\n');

    // Convert the buffer to a string slice (excluding the newline)
    const name = line[0 .. line.len - 1];

    // Greet the user
    try stdout.print("Hello, {s}\n", .{name});
}
