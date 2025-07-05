const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // エンジンライブラリのモジュール
    const lib_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // 実行ファイルのモジュール
    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // exe_modからlib_modをインポート
    exe_mod.addImport("corestone_engine_lib", lib_mod);

    // 静的ライブラリの作成
    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "corestone_engine",
        .root_module = lib_mod,
    });

    // SDL2のシステムライブラリをリンク
    lib.linkSystemLibrary("SDL2");
    lib.linkLibC();

    b.installArtifact(lib);

    // 実行ファイルの作成
    const exe = b.addExecutable(.{
        .name = "corestone_engine",
        .root_module = exe_mod,
    });

    // SDL2のシステムライブラリをリンク
    exe.linkSystemLibrary("SDL2");
    exe.linkLibC();

    // プラットフォーム固有の設定
    if (target.result.os.tag == .windows) {
        // Windowsの場合、SDL2のパスを明示的に指定する必要があるかもしれません
        // exe.addIncludePath(.{ .path = "C:/SDL2/include" });
        // exe.addLibraryPath(.{ .path = "C:/SDL2/lib/x64" });
    }

    b.installArtifact(exe);

    // 実行ステップ
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // テストステップ
    const lib_unit_tests = b.addTest(.{
        .root_module = lib_mod,
    });
    lib_unit_tests.linkSystemLibrary("SDL2");
    lib_unit_tests.linkLibC();

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
    });
    exe_unit_tests.linkSystemLibrary("SDL2");
    exe_unit_tests.linkLibC();

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}