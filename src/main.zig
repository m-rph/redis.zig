const std = @import("std");
const net = std.net;
const address = "127.0.0.1";
const port = 6379;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Logs from your program will appear here!\n", .{});
    try stdout.print("listening to {s}:{d}\n", .{ address, port });

    const address_and_port = try net.Address.resolveIp(address, 6379);

    var listener = try address_and_port.listen(.{
        .reuse_address = true,
    });
    defer listener.deinit();
    while (true) {
        const connection = try listener.accept();
        defer connection.stream.close();
        try stdout.print("accepted new connection\n", .{});
    }
}
