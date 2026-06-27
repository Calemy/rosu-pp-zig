const c = @import("c.zig").c;
const GameMode = @import("pp.zig").GameMode;

pub const State = extern struct {
    max_combo: u32 = 0,
    osu_large_tick_hits: u32 = 0,
    osu_small_tick_hits: u32 = 0,
    slider_end_hits: u32 = 0,
    n_geki: u32 = 0,
    n_katu: u32 = 0,
    n300: u32 = 0,
    n100: u32 = 0,
    n50: u32 = 0,
    misses: u32 = 0,
    legacy_total_score: u32 = 0,
    legacy_total_score_valid: bool = false,

    pub fn hits(self: @This(), mode: GameMode) c_uint {
        c.rosu_pp_score_state_total_hits(@ptrCast(&self), mode);
    }
};

pub fn newState() State {
    return .{};
}
