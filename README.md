# rosu-pp-zig
a zig ready version of rosu-pp

THIS IS NOT READY FOR PRODUCTION. IT DOES THE BARE MINIMUM AT THE MOMENT.


Current rosu-pp version: 4.0.1

---

##  How to use it

### Download the module

```bash
zig fetch --save git+"https://github.com/Calemy/rosu-pp-zig"
```

### Example

Beatmaps currently are created from files. You'll be able to pass in the raw data in the future.

```zig
const std = @import("std");
const rosu = @import("rosu-pp-zig");

pub fn main(_: std.process.Init) !void {
    var map: rosu.Beatmap = .init("75.osu");
    defer map.deinit();

    var zps: rosu.Calculator.Params = .init();
    // This is a pointer and can be chahined.
    _ = zps.mods(72).accuracy(100); // Due to zig's nature it has to be explicitly discarded.
    const d1 = map.calculate(&zps);
    std.log.info("100% - {}pp {} stars", .{ d1.pp, d1.stars });
    _ = zps.accuracy(99);
    const d2 = map.calculate(&zps);
    std.log.info("99% - {}pp {} stars", .{ d2.pp, d2.stars });
}
```

---

## Roadmap

There's a list of things that need to be improved or implemented including:
- Load Beatmap via bytes
- Load Beatmap difficulty attributes
- Proper free functions for everything.
- full rosu-pp library support

If you find this package useful, feel free to leave a star on the repository!


Contributions are always welcomed via issues and PRs.
