const std = @import("std");

// SDL2ヘッダーを直接インポート
const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

pub fn main() !void {
    // SDL2の初期化
    if (c.SDL_Init(c.SDL_INIT_VIDEO) != 0) {
        std.log.err("SDL_Init failed: {s}", .{c.SDL_GetError()});
        return error.SDLInitFailed;
    }
    defer c.SDL_Quit();

    // ウィンドウの作成
    const window = c.SDL_CreateWindow(
        "Corestone Engine",
        c.SDL_WINDOWPOS_CENTERED,
        c.SDL_WINDOWPOS_CENTERED,
        800,
        600,
        c.SDL_WINDOW_SHOWN,
    ) orelse {
        std.log.err("SDL_CreateWindow failed: {s}", .{c.SDL_GetError()});
        return error.WindowCreationFailed;
    };
    defer c.SDL_DestroyWindow(window);

    std.log.info("Corestone Engine initialized successfully!", .{});
    std.log.info("Window created: 800x600", .{});

    // メインループ
    var quit = false;
    var event: c.SDL_Event = undefined;
    
    while (!quit) {
        // イベント処理
        while (c.SDL_PollEvent(&event) != 0) {
            switch (event.type) {
                c.SDL_QUIT => {
                    quit = true;
                },
                c.SDL_KEYDOWN => {
                    if (event.key.keysym.sym == c.SDLK_ESCAPE) {
                        quit = true;
                    }
                },
                else => {},
            }
        }

        // 画面をクリア（黒色）
        const renderer = c.SDL_GetRenderer(window);
        if (renderer) |r| {
            _ = c.SDL_SetRenderDrawColor(r, 0, 0, 0, 255);
            _ = c.SDL_RenderClear(r);
            c.SDL_RenderPresent(r);
        }

        // CPUを休ませる（約60FPS）
        c.SDL_Delay(16);
    }

    std.log.info("Shutting down Corestone Engine...", .{});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit();
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}