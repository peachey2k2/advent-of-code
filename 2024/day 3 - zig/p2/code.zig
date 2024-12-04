const std = @import("std");

const FuncState = enum {
    invalid,
    char_m,
    char_u,
    char_l,
    char_bracket_mul,
    num1,
    char_comma,
    num2,

    char_d,
    char_o,
    char_n,
    char_apostrophe,
    char_t,
    char_bracket_do,
    char_bracket_dont,
};

pub fn to_num(char: u8) ?i32 {
    if (char < '0' or char > '9') return null;
    return char - '0';
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const file = try std.fs.cwd().openFile("../input.txt", .{ .mode = .read_only });
    defer file.close();

    var sum: i32 = 0;
    var enabled = true;

    const contents = try file.readToEndAlloc(allocator, ~@as(usize, 0));
    var it = std.mem.splitSequence(u8, contents, "\n");
    while (it.next()) |line| {
        var state = FuncState.invalid;
        var accum1: i32 = 0;
        var accum2: i32 = 0;
        for (line) |char| {
            switch (state) {
                .invalid => if (char == 'm' and enabled) {
                    state = .char_m;
                } else if (char == 'd') {
                    state = .char_d;
                } else {
                    state = .invalid;
                },
                .char_m => if (char == 'u') {
                    state = .char_u;
                } else {
                    state = .invalid;
                    continue;
                },
                .char_u => if (char == 'l') {
                    state = .char_l;
                } else {
                    state = .invalid;
                    continue;
                },
                .char_l => if (char == '(') {
                    state = .char_bracket_mul;
                } else {
                    state = .invalid;
                    continue;
                },
                .char_bracket_mul => if (to_num(char)) |digit| {
                    accum1 = digit;
                    state = .num1;
                } else {
                    state = .invalid;
                    continue;
                },
                .num1 => if (to_num(char)) |digit| {
                    accum1 = 10 * accum1 + digit;
                } else if (char == ',') {
                    state = .char_comma;
                } else {
                    state = .invalid;
                    continue;
                },
                .char_comma => if (to_num(char)) |digit| {
                    accum2 = digit;
                    state = .num2;
                } else {
                    state = .invalid;
                    continue;
                },
                .num2 => if (to_num(char)) |digit| {
                    accum2 = 10 * accum2 + digit;
                } else if (char == ')') {
                    sum += accum1 * accum2;
                    state = .invalid;
                } else {
                    state = .invalid;
                    continue;
                },

                .char_d => if (char == 'o') {
                    state = .char_o;
                } else {
                    state = .invalid;
                    continue;
                },
                .char_o => if (char == 'n') {
                    state = .char_n;
                } else if (char == '(') {
                    state = .char_bracket_do;
                } else {
                    state = .invalid;
                    continue;
                },
                .char_n => if (char == '\'') {
                    state = .char_apostrophe;
                } else {
                    state = .invalid;
                    continue;
                },
                .char_apostrophe => if (char == 't') {
                    state = .char_t;
                } else {
                    state = .invalid;
                    continue;
                },
                .char_t => if (char == '(') {
                    state = .char_bracket_dont;
                } else {
                    state = .invalid;
                    continue;
                },

                .char_bracket_do => if (char == ')') {
                    enabled = true;
                    state = .invalid;
                } else {
                    state = .invalid;
                },
                .char_bracket_dont => if (char == ')') {
                    enabled = false;
                    state = .invalid;
                } else {
                    state = .invalid;
                },
            }
        }
    }

    std.debug.print("{d}\n", .{sum});
}
