const c = @import("c.zig").c;
const std = @import("std");

const Beatmap = @import("beatmap.zig");
const Difficulty = @import("difficulty.zig");
const Score = @import("score.zig");
const Mods = @import("mods.zig").Mods;
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
        return .{ .handle = c.rosu_pp_performance_new_from_attrs(@ptrCast(&self)) };
    }
};

pub const Priority = enum(u32) {
    BestCase = 0,
    WorstCase = 1,
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

    pub fn mods(self: Self, value: Mods) Performance {
        _ = c.rosu_pp_performance_mods(self.handle, value.handle);
        return self;
    }

    pub fn objects(self: Self, value: u32) Performance {
        _ = c.rosu_pp_performance_passed_objects(self.handle, value);
        return self;
    }

    pub fn clockRate(self: Self, value: f64) Performance {
        _ = c.rosu_pp_performance_clock_rate(self.handle, value);
        return self;
    }

    pub fn ar(self: Self, value: f32, fixed: bool) Performance {
        _ = c.rosu_pp_performance_ar(self.handle, value, fixed);
        return self;
    }

    pub fn cs(self: Self, value: f32, fixed: bool) Performance {
        _ = c.rosu_pp_performance_cs(self.handle, value, fixed);
        return self;
    }

    pub fn hp(self: Self, value: f32, fixed: bool) Performance {
        _ = c.rosu_pp_performance_hp(self.handle, value, fixed);
        return self;
    }

    pub fn od(self: Self, value: f32, fixed: bool) Performance {
        _ = c.rosu_pp_performance_od(self.handle, value, fixed);
        return self;
    }

    pub fn hardrockOffset(self: Self, value: bool) Performance {
        _ = c.rosu_pp_performance_hardrock_offsets(self.handle, value);
        return self;
    }

    pub fn lazer(self: Self, value: bool) Performance {
        _ = c.rosu_pp_performance_lazer(self.handle, value);
        return self;
    }

    pub fn accuracy(self: Self, value: f64) Performance {
        _ = c.rosu_pp_performance_accuracy(self.handle, value);
        return self;
    }

    pub fn misses(self: Self, value: u32) Performance {
        _ = c.rosu_pp_performance_misses(self.handle, value);
        return self;
    }

    pub fn combo(self: Self, value: u32) Performance {
        _ = c.rosu_pp_performance_combo(self.handle, value);
        return self;
    }

    pub fn largeTickHits(self: Self, value: u32) Performance {
        _ = c.rosu_pp_performance_large_tick_hits(self.handle, value);
        return self;
    }

    pub fn smallTickHits(self: Self, value: u32) Performance {
        _ = c.rosu_pp_performance_small_tick_hits(self.handle, value);
        return self;
    }

    pub fn sliderEndHits(self: Self, value: u32) Performance {
        _ = c.rosu_pp_performance_slider_end_hits(self.handle, value);
        return self;
    }

    pub fn n300(self: Self, value: u32) Performance {
        _ = c.rosu_pp_performance_n300(self.handle, value);
        return self;
    }

    pub fn n100(self: Self, value: u32) Performance {
        _ = c.rosu_pp_performance_n100(self.handle, value);
        return self;
    }

    pub fn n50(self: Self, value: u32) Performance {
        _ = c.rosu_pp_performance_n50(self.handle, value);
        return self;
    }

    pub fn geki(self: Self, value: u32) Performance {
        _ = c.rosu_pp_performance_n_geki(self.handle, value);
        return self;
    }

    pub fn katu(self: Self, value: u32) Performance {
        _ = c.rosu_pp_performance_n_katu(self.handle, value);
        return self;
    }

    pub fn legacyScore(self: Self, value: u32) Performance {
        _ = c.rosu_pp_performance_legacy_total_score(self.handle, value);
        return self;
    }

    pub fn hitPriority(self: Self, value: Priority) Performance {
        _ = c.rosu_pp_performance_hitresult_priority(self.handle, value);
        return self;
    }

    pub fn state(self: Self, score: Score.State) Performance {
        _ = c.rosu_pp_performance_state(self.handle, @ptrCast(&score));
        return self;
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
