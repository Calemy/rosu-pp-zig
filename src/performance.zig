const c = @import("c.zig").c;
const std = @import("std");

const Beatmap = @import("beatmap.zig");
const Difficulty = @import("difficulty.zig");
const Score = @import("score.zig");
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

    /// If called you no longer require to deinit.
    pub fn calculate(self: Self) Attributes {
        var attr: Attributes = std.mem.zeroes(Attributes);
        _ = Handle.rosu_pp_performance_calculate(self.handle, @ptrCast(&attr));
        return attr;
    }

    /// Calculates performing map suspicion checks. If called you no longer require to deinit.
    pub fn calculateSafe(self: Self) error{TooSuspicious}!Attributes {
        var attr: Attributes = std.mem.zeroes(Attributes);
        const result: FFIResult = @enumFromInt(Handle.rosu_pp_performance_checked_calculate(self.handle, @ptrCast(&attr)));
        if (result == .TooSuspicious) return error.TooSuspicious;
        return attr;
    }

    pub fn state(self: Self, score: Score.State) Performance {
        _ = c.rosu_pp_performance_state(self.handle, @ptrCast(&score));
        return self;
    }
};

const Iterator = struct {
    value: Attributes,
    done: bool,
};

pub const Gradual = struct {
    const Self = @This();
    handle: ?*Handle,

    pub fn init(difficulty: Difficulty.Difficulty, beatmap: Beatmap.Beatmap) Gradual {
        return .{ .handle = c.rosu_pp_gradual_difficulty_new(difficulty.handle, beatmap.handle) };
    }

    pub fn deinit(self: Self) void {
        c.rosu_pp_gradual_performance_free(self.handle);
    }

    pub fn free(self: Self) void {
        c.rosu_pp_gradual_performance_free(self.handle);
    }

    pub fn next(self: Self, score: Score.State) Iterator {
        var attr = Attributes{};
        const result: FFIResult = @enumFromInt(c.rosu_pp_gradual_performance_next(self.handle, @ptrCast(&score), @ptrCast(&attr)));
        return .{ .value = attr, .done = result == .Done };
    }
};
