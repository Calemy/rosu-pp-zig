const c = @import("c.zig").c;

const Performance = @import("performance.zig").Performance;
const Difficulty = @import("difficulty.zig").Difficulty;
const Mods = @import("mods.zig").Mods;
const rosu = @import("pp.zig");
const FFIResult = rosu.FFIResult;

const BeatmapHandle = c.rosu_pp_BeatmapHandle;

pub const AttributesBuilder = struct {
    const Self = @This();
    handle: ?*c.rosu_pp_BeatmapAttributesBuilderHandle,

    pub fn init() AttributesBuilder {
        return .{ .handle = c.rosu_pp_beatmap_attrs_builder_new() };
    }

    pub fn deinit(self: Self) void {
        c.rosu_pp_beatmap_attrs_builder_free(self);
    }

    pub fn free(self: Self) void {
        c.rosu_pp_beatmap_attrs_builder_free(self);
    }

    pub fn map(self: Self, value: Beatmap) AttributesBuilder {
        _ = c.rosu_pp_beatmap_attrs_builder_map(self.handle, value.handle);
        return self;
    }

    pub fn ar(self: Self, value: f32, fixed: bool) AttributesBuilder {
        _ = c.rosu_pp_beatmap_attrs_builder_ar(self.handle, value, fixed);
        return self;
    }

    pub fn od(self: Self, value: f32, fixed: bool) AttributesBuilder {
        _ = c.rosu_pp_beatmap_attrs_builder_od(self.handle, value, fixed);
        return self;
    }

    pub fn cs(self: Self, value: f32, fixed: bool) AttributesBuilder {
        _ = c.rosu_pp_beatmap_attrs_builder_cs(self.handle, value, fixed);
        return self;
    }

    pub fn hp(self: Self, value: f32, fixed: bool) AttributesBuilder {
        _ = c.rosu_pp_beatmap_attrs_builder_hp(self.handle, value, fixed);
        return self;
    }

    pub fn mods(self: Self, value: Mods) AttributesBuilder {
        _ = c.rosu_pp_beatmap_attrs_builder_mods(self.handle, value.handle);
        return self;
    }

    pub fn clockRate(self: Self, value: f64) AttributesBuilder {
        _ = c.rosu_pp_beatmap_attrs_builder_hp(self.handle, value);
        return self;
    }

    pub fn mode(self: Self, value: rosu.GameMode, isConvert: bool) AttributesBuilder {
        _ = c.rosu_pp_beatmap_attrs_builder_mode(self.handle, value, isConvert);
        return self;
    }

    pub fn difficulty(self: Self, value: Difficulty) AttributesBuilder {
        c.rosu_pp_beatmap_attrs_builder_difficulty(self.handle, value.handle);
        return self;
    }

    pub fn build(self: *Self) Attributes {
        return .{ .handle = c.rosu_pp_beatmap_attrs_builder_build(self.handle) };
    }
};

const Adjusted = extern struct {
    ar: f64 = 0,
    cs: f32 = 0,
    hp: f32 = 0,
    od: f64 = 0,
};

const HitWindows = extern struct {
    ar: f64 = 0,
    od_perfect: f64 = 0,
    od_great: f64 = 0,
    od_good: f64 = 0,
    od_ok: f64 = 0,
    od_meh: f64 = 0,
};

pub const Attributes = struct {
    const Self = @This();
    handle: ?*c.rosu_pp_BeatmapAttributesHandle,

    pub fn applyClockRate(self: Self) Adjusted {
        var attr = Adjusted{};
        _ = c.rosu_pp_beatmap_attrs_apply_clock_rate(self.handle, @ptrCast(&attr));
        return attr;
    }

    pub fn hitWindows(self: Self) HitWindows {
        var hw = HitWindows{};
        _ = c.rosu_pp_beatmap_attrs_hit_windows(self.handle, @ptrCast(&hw));
        return hw;
    }

    pub fn deinit(self: Self) void {
        c.rosu_pp_beatmap_attrs_free(self.handle);
    }

    pub fn free(self: Self) void {
        c.rosu_pp_beatmap_attrs_free(self.handle);
    }
};

pub const Beatmap = struct {
    const Self = @This();
    handle: ?*c.rosu_pp_BeatmapHandle = null,

    pub fn deinit(self: Self) void {
        c.rosu_pp_BeatmapHandle.rosu_pp_beatmap_free(self.handle);
    }

    pub fn fromPath(path: [*c]const u8) !Beatmap {
        var handle: ?*BeatmapHandle = null;
        const res: FFIResult = @enumFromInt(c.rosu_pp_beatmap_from_path(path, &handle));
        try res.check();
        return .{ .handle = handle };
    }

    pub fn fromBytes(bytes: [*c]const u8, len: usize) !Beatmap {
        var handle: ?*BeatmapHandle = null;
        const res: FFIResult = @enumFromInt(c.rosu_pp_beatmap_from_bytes(bytes, len, &handle));
        try res.check();
        return .{ .handle = handle };
    }

    pub fn newCalc(self: Self) Performance {
        return .{ .handle = c.rosu_pp_performance_new(self.handle) };
    }
};
