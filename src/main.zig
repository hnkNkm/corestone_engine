const std = @import("std");
const gl = @import("renderer/opengl/gl.zig");
const OpenGLContext = @import("renderer/opengl/context.zig").OpenGLContext;
const shader = @import("renderer/opengl/shader.zig");

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

    // シェーダーの作成
    var vertex_shader = try shader.Shader.init(shader.basic_vertex_shader, .vertex);
    defer vertex_shader.deinit();
    
    var fragment_shader = try shader.Shader.init(shader.basic_fragment_shader, .fragment);
    defer fragment_shader.deinit();
    
    var shader_program = try shader.ShaderProgram.init(&vertex_shader, &fragment_shader);
    defer shader_program.deinit();

    // 三角形の頂点データ
    const vertices = [_]gl.GLfloat{
        // 位置
        -0.5, -0.5, 0.0,  // 左下
         0.5, -0.5, 0.0,  // 右下
         0.0,  0.5, 0.0,  // 上
    };

    // VAOとVBOの作成
    var vao: gl.GLuint = 0;
    var vbo: gl.GLuint = 0;
    
    gl.glGenVertexArrays(1, &vao);
    gl.glGenBuffers(1, &vbo);
    
    // VAOをバインド
    gl.glBindVertexArray(vao);
    
    // VBOをバインドしてデータをコピー
    gl.glBindBuffer(gl.GL_ARRAY_BUFFER, vbo);
    gl.glBufferData(gl.GL_ARRAY_BUFFER, @sizeOf(@TypeOf(vertices)), &vertices, gl.GL_STATIC_DRAW);
    
    // 頂点属性を設定
    gl.glVertexAttribPointer(0, 3, gl.GL_FLOAT, gl.GL_FALSE, 3 * @sizeOf(gl.GLfloat), null);
    gl.glEnableVertexAttribArray(0);
    
    // バインドを解除
    gl.glBindBuffer(gl.GL_ARRAY_BUFFER, 0);
    gl.glBindVertexArray(0);

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
        
        // シェーダープログラムを使用
        shader_program.use();
        
        // 三角形を描画
        gl.glBindVertexArray(vao);
        gl.glDrawArrays(gl.GL_TRIANGLES, 0, 3);
        gl.glBindVertexArray(0);
        
        // バッファをスワップ
        gl_context.swapBuffers();
    }
    
    // クリーンアップ
    gl.glDeleteVertexArrays(1, &vao);
    gl.glDeleteBuffers(1, &vbo);

    std.log.info("Shutting down Corestone Engine...", .{});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit();
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}