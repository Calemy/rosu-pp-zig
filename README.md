# rosu-pp-zig
a zig ready version of rosu-pp

Current rosu-pp version: 4.0.1

It makes use of the new rosu-pp-ffi library created by @Badewanne3 and will stay compatible with it.

I have been made aware of the lack of source code for the FFI. It will be added when this package is production ready with proper CI/CD.
---

##  How to use it

### Download the module

```bash
zig fetch --save git+"https://github.com/Calemy/rosu-pp-zig"
```

### Example

Beatmaps currently are created from files. You can also pass in the raw data.

```zig
const std = @import("std");
const rosu = @import("rosu-pp-zig");

pub fn main(_: std.process.Init) !void {
    const map: rosu.Beatmap.Beatmap = try .fromPath("75.osu");
    defer map.deinit();

    const mods: rosu.Mods = .fromBits(72);
    defer mods.free();

    const b = map.calculator();
    errdefer b.free();

    const base = b.calculate();
    const accuracies = [_]f32{ 100, 99, 98, 95 };

    for (accuracies) |acc| {
        const perf = base.calculator();
        errdefer perf.free();
        const result = perf.mods(mods).accuracy(acc).calculate();
        std.log.info("{d:.2}pp - {d:.2}%", .{ result.pp, acc });
    }
}
```

---

## Roadmap

There's a list of things that need to be improved or implemented including:
- full rosu-pp library support (done?)
- be able to clone performance calculator

If you find this package useful, feel free to leave a star on the repository!


Contributions are always welcomed via issues and PRs.
