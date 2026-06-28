const c = @import("c.zig").c;
pub const Beatmap = @import("beatmap.zig");
pub const Performance = @import("performance.zig");
pub const Difficulty = @import("difficulty.zig");
pub const Score = @import("score.zig");
pub const Mods = @import("mods.zig").Mods;

pub const TooSuspicious = error.TooSuspicious;

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

pub const GameMode = enum(c_uint) {
    Osu = 0,
    Taiko = 1,
    Catch = 2,
    Mania = 3,

    pub fn fromString(s: c_char) error{InvalidArgument}!GameMode {
        var num: c_uint = null;
        const result: FFIResult = @enumFromInt(c.rosu_pp_mode_from_str(s, &num));
        if (result == .InvalidArgument) return error.InvalidArgument;
        return @enumFromInt(num);
    }
};
