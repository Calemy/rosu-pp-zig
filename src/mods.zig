const c = @import("c.zig").c;
const rosu = @import("pp.zig");

const FFIResult = rosu.FFIResult;

pub const Mods = struct {
    const Self = @This();
    handle: ?*c.rosu_pp_ModsHandle,

    pub fn fromBits(value: u32) Mods {
        return .{ .handle = c.rosu_pp_mods_from_bits(value) };
    }

    pub fn fromAcronym(value: [*c]const u8) error{ParseError}!Mods {
        var mods = Mods{ .handle = null };
        const result: FFIResult = @enumFromInt(c.rosu_pp_mods_from_acronym(value, &mods.handle));
        try result.check();

        return mods;
    }

    pub fn fromJson(value: [*c]const u8, denyUnknownFields: bool) error{ParseError}!Mods {
        var mods = Mods{ .handle = null };
        const result: FFIResult = @enumFromInt(c.rosu_pp_mods_from_json(value, denyUnknownFields, &mods.handle));
        try result.check();
        return mods;
    }

    pub fn fromJsonWithMode(value: [*c]const u8, denyUnknownFields: bool, mode: rosu.GameMode) error{ParseError}!Mods {
        var mods = Mods{ .handle = null };
        const result: FFIResult = @enumFromInt(c.rosu_pp_mods_from_json_with_mode(value, denyUnknownFields, mode, &mods.handle));
        try result.check();
        return mods;
    }

    pub fn deinit(self: Self) void {
        c.rosu_pp_mods_free(self.handle);
    }

    pub fn free(self: Self) void {
        c.rosu_pp_mods_free(self.handle);
    }

    pub fn freeString(value: [*c]const u8) void {
        c.rosu_pp_mods_free_string(value);
    }

    pub fn bits(self: Self) u32 {
        return c.rosu_pp_mods_to_bits(self.handle);
    }

    pub fn string(self: Self) [*c]u8 {
        return c.rosu_pp_mods_to_string(self.handle);
    }
};
