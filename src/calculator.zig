pub const CalculatorParams = opaque {};
pub const CalculatorResult = extern struct {
    pp: f64,
    pp_aim: f64,
    pp_speed: f64,
    pp_flashlight: f64,
    pp_acc: f64,
    stars: f64,
};

extern fn create_calculator_params() *CalculatorParams;
extern fn params_set_mode(params: *CalculatorParams, mode: u8) void;
extern fn params_set_combo(params: *CalculatorParams, combo: u32) void;
extern fn params_set_n300(params: *CalculatorParams, count: u32) void;
extern fn params_set_n100(params: *CalculatorParams, count: u32) void;
extern fn params_set_n50(params: *CalculatorParams, count: u32) void;
extern fn params_set_mmiss(params: *CalculatorParams, count: u32) void;
extern fn params_set_ngeki(params: *CalculatorParams, count: u32) void;
extern fn params_set_nkatu(params: *CalculatorParams, count: u32) void;
extern fn params_set_mods(params: *CalculatorParams, mods: u32) void;
extern fn params_set_accuracy(params: *CalculatorParams, accuracy: f64) void;

pub const Params = struct {
    params: *CalculatorParams,

    const Self = @This();

    pub fn init() Self {
        return .{ .params = create_calculator_params() };
    }

    pub fn deinit(self: *Self) void {
        self.params = null;
    }

    pub fn mode(self: *Self, modeInt: u8) *Self {
        params_set_mode(self.params, modeInt);
        return self;
    }

    pub fn combo(self: *Self, count: u32) *Self {
        params_set_combo(self.params, count);
        return self;
    }

    pub fn n300(self: *Self, count: u32) *Self {
        params_set_n300(self.params, count);
        return self;
    }

    pub fn n100(self: *Self, count: u32) *Self {
        params_set_n100(self.params, count);
        return self;
    }

    pub fn n50(self: *Self, count: u32) *Self {
        params_set_n50(self.params, count);
        return self;
    }

    pub fn ngeki(self: *Self, count: u32) *Self {
        params_set_ngeki(self.params, count);
        return self;
    }

    pub fn nkatu(self: *Self, count: u32) *Self {
        params_set_nkatu(self.params, count);
        return self;
    }

    pub fn mods(self: *Self, modInt: u32) *Self {
        params_set_mods(self.params, modInt);
        return self;
    }

    pub fn accuracy(self: *Self, acc: f64) *Self {
        params_set_accuracy(self.params, acc);
        return self;
    }
};
