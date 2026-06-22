const c = @import("c.zig").c;

const Performance = @import("performance.zig").Performance;
const rosu = @import("pp.zig");
const FFIResult = rosu.FFIResult;

const BeatmapHandle = c.rosu_pp_BeatmapHandle;

pub const Attributes = struct {
    const Self = @This();
    handle: ?*c.rosu_pp_BeatmapAttributesHandle,

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
