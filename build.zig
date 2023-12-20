const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    concatDays();

    const exe = b.addExecutable(.{
        .name = "adventofcode",
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}

pub fn concatDays() void {
    var buff: [1 << 20]u8 = undefined;
    var _fba = std.heap.FixedBufferAllocator.init(&buff);
    const fba = _fba.allocator();
    const cwd = std.fs.cwd();
    var file = cwd.createFile("./src/list.zig", .{}) catch unreachable;
    var fw = file.writer();
    fw.print(
        "const prc = @import(\"process.zig\");\n\n",
        .{},
    ) catch unreachable;
    fw.print(
        "pub fn proc(p: prc.Proc) void {c}\n    switch (p.year) {c}\n",
        .{ '{', '{' },
    ) catch unreachable;

    var dir = cwd.openDir("./src/", .{ .iterate = true }) catch unreachable;
    var walker = dir.walk(fba) catch unreachable;
    while (walker.next() catch unreachable) |sub| {
        if (sub.kind == .directory) {
            const subname = std.fmt.allocPrint(
                fba,
                "./src/{s}/",
                .{sub.basename},
            ) catch unreachable;
            var subdir = cwd.openDir(subname, .{ .iterate = true }) catch unreachable;
            fba.free(subname);
            var sub_walker = subdir.walk(fba) catch unreachable;
            fw.print(
                "        {d} => {c} \n            switch (p.day) {c}\n",
                .{ std.fmt.parseInt(i16, sub.basename, 10) catch unreachable, '{', '{' },
            ) catch unreachable;
            var int: u8 = 1;
            while (sub_walker.next() catch unreachable) |subfile| {
                fw.print(
                    "                {d} => @import(\"{s}/{s}\").Day.proc(p),\n",
                    .{ int, sub.basename, subfile.basename },
                ) catch unreachable;
                int += 1;
            }
            fw.print(
                "                else => {c}{c},\n            {c}\n        {c},\n",
                .{ '{', '}', '}', '}' },
            ) catch unreachable;
            subdir.close();
            sub_walker.deinit();
        }
    }
    fw.print("        else => {c}{c},\n    {c}\n{c}\n", .{ '{', '}', '}', '}' }) catch unreachable;

    file.close();
    dir.close();
    walker.deinit();
}
