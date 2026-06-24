const c = @import("c.zig").c;
const Performance = @import("performance.zig");

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

    pub fn newCalc(self: @This()) Performance.Performance {
        return .{ .handle = c.rosu_pp_performance_new_from_diff_attrs(self) };
    }
};

pub const Difficulty = struct {
    const Self = @This();
    handle: ?*c.rosu_pp_DifficultyHandle,

    pub fn init() Difficulty {
        return .{ .handle = c.rosu_pp_difficulty_new() };
    }

    pub fn deinit(self: Self) void {
        c.rosu_pp_difficulty_free(self.handle);
    }

    pub fn free(self: Self) void {
        c.rosu_pp_difficulty_free(self.handle);
    }
};
