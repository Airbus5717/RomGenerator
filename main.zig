const std = @import("std");


// memory layout (u8 -> unsigned 8 bit)
const CU = packed struct(u8) {
    BusW: u2,
    RegDest: u2,
    AluB: u2,
    PCSrc: u2,
};

const opControl = [_]CU{
    // R-type (opcodes from 0 to 2 are 3 opcodes only)
    .{ .BusW = 0, .RegDest = 0, .AluB = 0, .PCSrc = 0 },
    .{ .BusW = 0, .RegDest = 0, .AluB = 0, .PCSrc = 0 },
    .{ .BusW = 0, .RegDest = 0, .AluB = 0, .PCSrc = 0 },
    // I-Type
    .{ .BusW = 0, .RegDest = 1, .AluB = 1, .PCSrc = 0 },
    .{ .BusW = 0, .RegDest = 1, .AluB = 1, .PCSrc = 0 },
    .{ .BusW = 0, .RegDest = 1, .AluB = 1, .PCSrc = 0 },
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 },
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 },
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 },
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 },
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 },
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 },
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 },
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 },
    // load & store
    .{ .BusW = 1, .RegDest = 1, .AluB = 1, .PCSrc = 0 },
    .{ .BusW = 0, .RegDest = 1, .AluB = 1, .PCSrc = 1 },
    // branch
    .{ .BusW = 0, .RegDest = 1, .AluB = 1, .PCSrc = 1 },
    .{ .BusW = 0, .RegDest = 1, .AluB = 1, .PCSrc = 1 },
    .{ .BusW = 0, .RegDest = 1, .AluB = 1, .PCSrc = 1 },
    .{ .BusW = 0, .RegDest = 1, .AluB = 1, .PCSrc = 0 },
    // jump, lui
    .{ .BusW = 2, .RegDest = 1, .AluB = 1, .PCSrc = 0 },
    .{ .BusW = 0, .RegDest = 2, .AluB = 3, .PCSrc = 0 },
    .{ .BusW = 0, .RegDest = 1, .AluB = 3, .PCSrc = 2 },
    .{ .BusW = 0, .RegDest = 3, .AluB = 3, .PCSrc = 2 },
};

pub fn main() !void {
    // CREATE FILE
    const file = try std.fs.cwd().createFile(
        "raw.hex",
        .{ .read = true },
    );
    defer file.close();

    _ = try file.writeAll("v2.0 raw\n");
    var i: usize = 0;
    while (i < opControl.len) : (i += 1) {
        const string = try std.fmt.allocPrint(
            std.heap.page_allocator,
            "{x}\t",
            .{@bitCast(u8, opControl[i])},
        );
        defer std.heap.page_allocator.free(string);
        _ = try file.write(string);
    }
    _ = try file.write("\n");
}
