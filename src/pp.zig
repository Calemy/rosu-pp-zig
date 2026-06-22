pub const Beatmap = @import("beatmap.zig");
pub const Performance = @import("performance.zig");
pub const Difficulty = @import("difficulty.zig");

pub const FFIResult = enum(c_uint) {
    Ok = 0,
    Done = 1,
    ParseError = 2,
    NullPointer = 3,
    InvalidArgument = 4,
    TooSuspicious = 5,
    None = 6,

    pub fn check(self: @This()) !void { //TODO: check if null may be better
        return switch (self) {
            .ParseError => error.ParseError,
            .NullPointer => error.NullPointer,
            .InvalidArgument => error.InvalidArgument,
            .TooSuspicious => error.TooSuspicious,
            .None => error.None,
            else => return,
        };
    }
};
