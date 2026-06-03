const calculator = @import("calculator.zig");

const CalculatorParams = calculator.CalculatorParams;
const CalculatorResult = calculator.CalculatorResult;

pub const BeatmapHandle = opaque {};

pub extern fn load_beatmap(path: [*:0]const u8) *BeatmapHandle;
pub extern fn free_beatmap(handle: *BeatmapHandle) void;
pub extern fn calculate_beatmap(handle: *BeatmapHandle, params: *CalculatorParams) *CalculatorResult;

pub const Beatmap = struct {
    handle: *BeatmapHandle,

    const Self = @This();

    pub fn init(path: [*:0]const u8) Self {
        return .{ .handle = load_beatmap(path) };
    }

    pub fn calculate(self: *Self, params: *calculator.Params) *CalculatorResult {
        return calculate_beatmap(self.handle, params.params);
    }

    pub fn deinit(self: *Self) void {
        return free_beatmap(self.handle);
    }

    pub fn free(self: *Self) void {
        return free_beatmap(self.handle);
    }
};
