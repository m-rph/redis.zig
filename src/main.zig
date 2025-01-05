const std = @import("std");
const net = std.net;
const io = std.io;
const address = "127.0.0.1";
const port = 6379;
const logging = @import("logging.zig");

fn handle_request(connection: net.Server.Connection, _: std.mem.Allocator) !void {
    defer connection.stream.close();
    const writer = connection.stream.writer();

    // let's reuse the same connection stream.
    // this can only accept one connection, but it doesn't matter yet.
    try writer.writeAll("+PONG\r\n");
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
        try logging.debug("accepted new connection\n", .{});
        const connection = try listener.accept();
        try handle_request(connection, allocator);
    }
}
