const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("rosu-pp", .{
        .root_source_file = b.path("src/pp.zig"),
        .target = target,
        .optimize = optimize,
    });

    mod.addLibraryPath(b.path("lib"));
    mod.linkSystemLibrary("rosu", .{});
    mod.linkSystemLibrary("unwind", .{});
}
