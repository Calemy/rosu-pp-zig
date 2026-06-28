const c = @import("c.zig").c;
const Performance = @import("performance.zig");
const Score = @import("score.zig");
const Mods = @import("mods.zig").Mods;
const Beatmap = @import("beatmap.zig").Beatmap;
const FFIResult = @import("pp.zig").FFIResult;

pub const Attributes = extern struct {
    mode: i32 = 0,
    stars: f64 = 0,
    max_combo: u32 = 0,
    aim: f64 = 0,
    speed: f64 = 0,
    flashlight: f64 = 0,
    stamina: f64 = 0,
    rhythm: f64 = 0,
    color: f64 = 0,
    reading: f64 = 0,
    ar: f64 = 0,
    hp: f64 = 0,
    great_hit_window: f64 = 0,
    ok_hit_window: f64 = 0,
    meh_hit_window: f64 = 0,
    n_circles: u32 = 0,
    n_sliders: u32 = 0,
    n_large_ticks: u32 = 0,
    n_spinners: u32 = 0,
    n_objects: u32 = 0,
    aim_difficult_slider_count: f64 = 0,
    slider_factor: f64 = 0,
    aim_top_weighted_slider_factor: f64 = 0,
    speed_top_weighted_slider_factor: f64 = 0,
    speed_note_count: f64 = 0,
    aim_difficult_strain_count: f64 = 0,
    speed_difficult_strain_count: f64 = 0,
    nested_score_per_object: f64 = 0,
    legacy_score_base_multiplier: f64 = 0,
    maximum_legacy_combo_score: f64 = 0,
    mono_stamina_factor: f64 = 0,
    mechanical_difficulty: f64 = 0,
    consistency_factor: f64 = 0,
    preempt: f64 = 0,
    n_fruits: u32 = 0,
    n_droplets: u32 = 0,
    n_tiny_droplets: u32 = 0,
    n_hold_notes: u32 = 0,
    is_convert: bool = false,

    pub fn calculator(self: @This()) Performance.Performance {
        return .{ .handle = c.rosu_pp_performance_new_from_diff_attrs(self) };
    }
};

pub const Difficulty = struct {
    const Self = @This();
    handle: ?*c.rosu_pp_DifficultyHandle,

    pub fn init() Difficulty {
        return .{ .handle = c.rosu_pp_difficulty_new() };
    }

    pub fn clone(self: Self) Difficulty {
        return .{ .handle = c.rosu_pp_difficulty_clone(self.handle) };
    }

    pub fn mods(self: Self, value: Mods) Difficulty {
        _ = c.rosu_pp_difficulty_mods(self.handle, value);
        return self;
    }

    pub fn objects(self: Self, value: u32) Difficulty {
        _ = c.rosu_pp_difficulty_passed_objects(self.handle, value);
        return self;
    }

    pub fn clockRate(self: Self, value: f64) Difficulty {
        _ = c.rosu_pp_difficulty_clock_rate(self.handle, value);
        return self;
    }

    pub fn ar(self: Self, value: f32, fixed: bool) Difficulty {
        _ = c.rosu_pp_difficulty_ar(self.handle, value, fixed);
        return self;
    }

    pub fn cs(self: Self, value: f32, fixed: bool) Difficulty {
        _ = c.rosu_pp_difficulty_cs(self.handle, value, fixed);
        return self;
    }

    pub fn hp(self: Self, value: f32, fixed: bool) Difficulty {
        _ = c.rosu_pp_difficulty_hp(self.handle, value, fixed);
        return self;
    }
    pub fn od(self: Self, value: f32, fixed: bool) Difficulty {
        _ = c.rosu_pp_difficulty_od(self.handle, value, fixed);
        return self;
    }

    pub fn hardrockOffset(self: Self, value: bool) Difficulty {
        _ = c.rosu_pp_difficulty_hardrock_offsets(self.handle, value);
        return self;
    }

    pub fn lazer(self: Self, value: bool) Difficulty {
        _ = c.rosu_pp_difficulty_lazer(self.handle, value);
        return self;
    }

    // If someone passes an empty Beatmap struct, they deserve to suffer for their idiocy.

    pub fn calculate(self: Self, beatmap: Beatmap) Attributes {
        var attr = Attributes{};
        const result: FFIResult = @enumFromInt(c.rosu_pp_difficulty_calculate(self.handle, beatmap.handle, @ptrCast(&attr)));
        try result.check();
        return attr;
    }

    pub fn checkedCalculate(self: Self, beatmap: Beatmap) error{TooSuspicious}!Attributes {
        var attr = Attributes{};
        const result: FFIResult = @enumFromInt(c.rosu_pp_difficulty_checked_calculate(self.handle, beatmap.handle, @ptrCast(&attr)));
        try result.check();
        return attr;
    }

    pub fn strains(self: Self, beatmap: Beatmap) Strain {
        var strain: *Strain = undefined;
        strain = @ptrCast(c.rosu_pp_difficulty_strains(self.handle, beatmap.handle));
        return strain.*;
    }

    pub fn gradualPerformance(self: Self, beatmap: Beatmap) Performance.Gradual {
        // TODO: Call Performance.Gradual.init() instead?
        return .{ .handle = c.rosu_pp_gradual_performance_new(self.handle, beatmap.handle) };
    }

    /// Consumes handle and returns `Inspect` struct. `Inspect` must be free'd seperately.
    pub fn inspect(self: Self) Inspect {
        return .{ .handle = c.rosu_pp_difficulty_inspect_new(self.handle) };
    }

    pub fn deinit(self: Self) void {
        c.rosu_pp_difficulty_free(self.handle);
    }

    pub fn free(self: Self) void {
        c.rosu_pp_difficulty_free(self.handle);
    }
};

pub const Inspect = struct {
    const Self = @This();
    handle: ?*c.rosu_pp_InspectDifficultyHandle,

    pub fn deinit(self: Self) void {
        c.rosu_pp_inspect_difficulty_free(self.handle);
    }

    pub fn free(self: Self) void {
        c.rosu_pp_inspect_difficulty_free(self.handle);
    }
};

const Iterator = struct {
    value: Attributes,
    done: bool,
};

pub const Gradual = struct {
    const Self = @This();
    handle: ?*c.rosu_pp_GradualDifficultyHandle,

    pub fn init(difficulty: Difficulty, beatmap: Beatmap) Gradual {
        return .{ .handle = c.rosu_pp_gradual_difficulty_new(difficulty.handle, beatmap.handle) };
    }

    pub fn deinit(self: Self) void {
        c.rosu_pp_gradual_difficulty_free(self.handle);
    }

    pub fn free(self: Self) void {
        c.rosu_pp_gradual_difficulty_free(self.handle);
    }

    pub fn next(self: Self) Iterator {
        var attr = Attributes{};
        const result: FFIResult = @enumFromInt(c.rosu_pp_gradual_difficulty_next(self.handle, @ptrCast(&attr)));
        return .{ .value = attr, .done = result == .Done };
    }
};

pub const Strain = extern struct {
    mode: i32 = 0,
    section_len: f64 = 0,
    len: usize = 0,
    aim: [*c]const f64 = null,
    aim_no_sliders: [*c]const f64 = null,
    speed: [*c]const f64 = null,
    flashlight: [*c]const f64 = null,
    stamina: [*c]const f64 = null,
    rhythm: [*c]const f64 = null,
    color: [*c]const f64 = null,
    reading: [*c]const f64 = null,
    single_color_stamina: [*c]const f64 = null,
    movement: [*c]const f64 = null,
    strains: [*c]const f64 = null,

    pub fn deinit(self: @This()) void {
        c.rosu_pp_strains_free(@ptrCast(self));
    }
    pub fn free(self: @This()) void {
        c.rosu_pp_strains_free(@ptrCast(self));
    }
};
