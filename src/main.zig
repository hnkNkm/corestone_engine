const std = @import("std");
const gl = @import("renderer/opengl/gl.zig");
const OpenGLContext = @import("renderer/opengl/context.zig").OpenGLContext;
const shader = @import("renderer/opengl/shader.zig");
const Texture = @import("renderer/opengl/texture.zig").Texture;
const sprite = @import("renderer/sprite.zig");

pub fn main() !void {
    // SDL2の初期化
    if (gl.c.SDL_Init(gl.c.SDL_INIT_VIDEO) != 0) {
        std.log.err("SDL_Init failed: {s}", .{gl.c.SDL_GetError()});
        return error.SDLInitFailed;
    }
    defer gl.c.SDL_Quit();

    // ウィンドウの作成（OpenGLフラグを追加）
    const window = gl.c.SDL_CreateWindow(
        "Corestone Engine - OpenGL",
        gl.c.SDL_WINDOWPOS_CENTERED,
        gl.c.SDL_WINDOWPOS_CENTERED,
        800,
        600,
        gl.c.SDL_WINDOW_SHOWN | gl.c.SDL_WINDOW_OPENGL,
    ) orelse {
        std.log.err("SDL_CreateWindow failed: {s}", .{gl.c.SDL_GetError()});
        return error.WindowCreationFailed;
    };
    defer gl.c.SDL_DestroyWindow(window);

    // OpenGLコンテキストの初期化
    var gl_context = try OpenGLContext.init(window);
    defer gl_context.deinit();

    // ビューポートの設定
    OpenGLContext.setViewport(800, 600);

    // アロケータの準備
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    // スプライトレンダラーを初期化
    var sprite_renderer = try sprite.SpriteRenderer.init(allocator, 800.0, 600.0);
    defer sprite_renderer.deinit();
    
    // テクスチャを作成
    var texture = try Texture.init();
    defer texture.deinit();
    try texture.createCheckerboard(allocator, 128);
    
    // スプライトを作成
    const test_sprite = sprite.Sprite.init(&texture);
    
    // シェーダーでテクスチャユニットを設定
    sprite_renderer.shader_program.use();
    const tex_location = gl.glGetUniformLocation(sprite_renderer.shader_program.id, "sprite_texture");
    gl.glUniform1i(tex_location, 0);

    std.log.info("OpenGL rendering initialized successfully!", .{});

    // メインループ
    var quit = false;
    var event: gl.c.SDL_Event = undefined;
    
    while (!quit) {
        // イベント処理
        while (gl.c.SDL_PollEvent(&event) != 0) {
            switch (event.type) {
                gl.c.SDL_QUIT => {
                    quit = true;
                },
                gl.c.SDL_KEYDOWN => {
                    if (event.key.keysym.sym == gl.c.SDLK_ESCAPE) {
                        quit = true;
                    }
                },
                else => {},
            }
        }

        // 画面をクリア（ダークブルー）
        OpenGLContext.clearScreen(0.1, 0.1, 0.2, 1.0);
        
        // 複数のスプライトを描画
        sprite_renderer.drawSprite(&test_sprite, 100.0, 100.0, 0.5);
        sprite_renderer.drawSprite(&test_sprite, 400.0, 300.0, 1.0);
        sprite_renderer.drawSprite(&test_sprite, 600.0, 200.0, 0.75);
        
        // バッファをスワップ
        gl_context.swapBuffers();
    }

    std.log.info("Shutting down Corestone Engine...", .{});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit();
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}