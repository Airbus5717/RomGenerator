const std = @import("std");


const CUsize = u8;
// memory layout (u8 -> unsigned 8 bit)
const CU = packed struct(CUsize) {
    BusW: u2,
    RegDest: u2,
    AluB: u2,
    PCSrc: u2,
};

const opControl = [_]CU{
    // R-type (opcodes from 0 to 2 are 3 opcodes only)
    .{ .BusW = 0, .RegDest = 0, .AluB = 0, .PCSrc = 0 }, // ADD ... SLTU
    .{ .BusW = 0, .RegDest = 0, .AluB = 0, .PCSrc = 0 }, // XOR ... NOR
    .{ .BusW = 0, .RegDest = 0, .AluB = 0, .PCSrc = 0 }, // SLL ... ROR
    // NOP
    .{ .BusW = 0, .RegDest = 0, .AluB = 0, .PCSrc = 0 }, // NOP
    // I-Type
    .{ .BusW = 0, .RegDest = 1, .AluB = 1, .PCSrc = 0 }, // ADDI
    .{ .BusW = 0, .RegDest = 0, .AluB = 0, .PCSrc = 0 }, // NOP
    .{ .BusW = 0, .RegDest = 1, .AluB = 1, .PCSrc = 0 }, // SLTI
    .{ .BusW = 0, .RegDest = 1, .AluB = 1, .PCSrc = 0 }, // SLTIU
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 }, // XORI
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 }, // ORI
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 }, // ANDI
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 }, // NORI
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 }, // SLLI
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 }, // SRLI
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 }, // SRAI
    .{ .BusW = 0, .RegDest = 1, .AluB = 2, .PCSrc = 0 }, // RORI
    // load & store
    .{ .BusW = 1, .RegDest = 1, .AluB = 1, .PCSrc = 0 }, // LW
    .{ .BusW = 0, .RegDest = 1, .AluB = 1, .PCSrc = 1 }, // SW
    // branch
    .{ .BusW = 0, .RegDest = 1, .AluB = 0, .PCSrc = 1 }, // BEQ
    .{ .BusW = 0, .RegDest = 1, .AluB = 0, .PCSrc = 1 }, // BNE
    .{ .BusW = 0, .RegDest = 1, .AluB = 0, .PCSrc = 1 }, // BLT
    .{ .BusW = 0, .RegDest = 1, .AluB = 0, .PCSrc = 0 }, // BGE
    // jump, lui
    .{ .BusW = 2, .RegDest = 1, .AluB = 1, .PCSrc = 0 }, // JALR
    .{ .BusW = 0, .RegDest = 3, .AluB = 3, .PCSrc = 0 }, // LUI
    .{ .BusW = 0, .RegDest = 1, .AluB = 3, .PCSrc = 2 }, // J
    .{ .BusW = 0, .RegDest = 3, .AluB = 3, .PCSrc = 2 }, // JAL
};

pub fn main() !void {
    // CREATE FILE
    const file = try std.fs.cwd().createFile("raw.hex", .{ .read = true });
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
