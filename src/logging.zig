const std = @import("std");
const io = std.io;
const fs = std.fs;

fn print_with_prefix(file: fs.File, comptime prefix: []const u8, comptime format: []const u8, args: anytype) !void {
    try file.writer().print(prefix, .{});
    try file.writer().print(format, args);
}

pub fn debug(comptime format: []const u8, args: anytype) !void {
    const stderr = io.getStdErr();
    try print_with_prefix(stderr, "[DEBUG] ", format, args);
}

pub fn info(comptime format: []const u8, args: anytype) !void {
    const stderr = io.getStdErr();
    try print_with_prefix(stderr, "[INFO] ", format, args);
}
