const c = @import("c.zig").c;
const std = @import("std");

const Beatmap = @import("beatmap.zig");
const Difficulty = @import("difficulty.zig");
const rosu = @import("pp.zig");

const Handle = c.rosu_pp_PerformanceHandle;
const FFIResult = rosu.FFIResult;

pub const Attributes = extern struct {
    pp: f64 = 0,
    pp_acc: f64 = 0,
    pp_aim: f64 = 0,
    pp_speed: f64 = 0,
    pp_flashlight: f64 = 0,
    pp_difficulty: f64 = 0,
    effective_miss_count: f64 = 0,
    speed_deviation: f64 = 0,
    combo_based_estimated_miss_count: f64 = 0,
    score_based_estimated_miss_count: f64 = 0,
    aim_estimated_slider_breaks: f64 = 0,
    speed_estimated_slider_breaks: f64 = 0,
    estimated_unstable_rate: f64 = 0,
    difficulty: Difficulty.Attributes = std.mem.zeroes(Difficulty.Attributes),

    pub fn newCalc(self: @This()) Performance {
        return .{ .handle = c.rosu_pp_performance_new_from_attrs(self) };
    }
};

pub const Performance = struct {
    const Self = @This();
    handle: ?*Handle,

    pub fn deinit(self: Self) void {
        c.rosu_pp_performance_free(self.handle);
    }

    pub fn free(self: Self) void {
        c.rosu_pp_performance_free(self.handle);
    }

    pub fn calc(self: Self) !Attributes {
        var attr: Attributes = std.mem.zeroes(Attributes);
        const result: FFIResult = @enumFromInt(Handle.calculate(self.handle, @ptrCast(&attr)));
        try result.check();
        return attr;
    }
};
