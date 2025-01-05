const std = @import("std");
const net = std.net;
const io = std.io;
const address = "127.0.0.1";
const port = 6379;
const logging = @import("logging.zig");

fn handle_request(connection: net.Server.Connection, allocator: std.mem.Allocator) !void {
    defer connection.stream.close();
    const writer = connection.stream.writer();
    const reader = connection.stream.reader();

    // let's reuse the same connection stream.
    // this can only accept one connection, but it doesn't matter yet.
    var buffer: []u8 = try allocator.alloc(u8, 1024);
    defer allocator.free(buffer);
    while (true) {
        const n = try reader.read(buffer[0..]);
        if (n == 0) {
            break;
        }
        try logging.debug("received {d} bytes\n", .{n});
        try logging.trace("received [{s}]\n", .{buffer});

        try writer.writeAll("+PONG\r\n");
    }
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const allocator = std.heap.page_allocator;

    try stdout.print("Logs from your program will appear here!\n", .{});
    try stdout.print("listening to {s}:{d}\n", .{ address, port });

    const address_and_port = try net.Address.resolveIp(address, 6379);

    var listener = try address_and_port.listen(.{
        .reuse_address = true,
    });
    defer listener.deinit();
    while (true) {
        const connection = try listener.accept();
        try logging.debug("accepted new connection\n", .{});
        try handle_request(connection, allocator);
    }
}
