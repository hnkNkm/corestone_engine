const std = @import("std");
const gl = @import("gl.zig");

pub const OpenGLContext = struct {
    context: gl.c.SDL_GLContext,
    window: *gl.c.SDL_Window,
    
    pub fn init(window: *gl.c.SDL_Window) !OpenGLContext {
        // OpenGL 3.3 Core Profileを設定
        if (gl.SDL_GL_SetAttribute(gl.SDL_GL_CONTEXT_MAJOR_VERSION, 3) != 0) {
            std.log.err("Failed to set OpenGL major version: {s}", .{gl.c.SDL_GetError()});
            return error.OpenGLAttributeError;
        }
        
        if (gl.SDL_GL_SetAttribute(gl.SDL_GL_CONTEXT_MINOR_VERSION, 3) != 0) {
            std.log.err("Failed to set OpenGL minor version: {s}", .{gl.c.SDL_GetError()});
            return error.OpenGLAttributeError;
        }
        
        if (gl.SDL_GL_SetAttribute(gl.SDL_GL_CONTEXT_PROFILE_MASK, gl.SDL_GL_CONTEXT_PROFILE_CORE) != 0) {
            std.log.err("Failed to set OpenGL profile: {s}", .{gl.c.SDL_GetError()});
            return error.OpenGLAttributeError;
        }
        
        // ダブルバッファリングを有効化
        if (gl.SDL_GL_SetAttribute(gl.SDL_GL_DOUBLEBUFFER, 1) != 0) {
            std.log.err("Failed to enable double buffering: {s}", .{gl.c.SDL_GetError()});
            return error.OpenGLAttributeError;
        }
        
        // OpenGLコンテキストを作成
        const context = gl.SDL_GL_CreateContext(window) orelse {
            std.log.err("Failed to create OpenGL context: {s}", .{gl.c.SDL_GetError()});
            return error.OpenGLContextCreationFailed;
        };
        
        // コンテキストをカレントに設定
        if (gl.SDL_GL_MakeCurrent(window, context) != 0) {
            std.log.err("Failed to make OpenGL context current: {s}", .{gl.c.SDL_GetError()});
            gl.SDL_GL_DeleteContext(context);
            return error.OpenGLContextError;
        }
        
        std.log.info("OpenGL context created successfully", .{});
        // OpenGL関数を初期化
        try gl.init();
        
        std.log.info("OpenGL version: {s}", .{gl.c.glGetString(gl.c.GL_VERSION)});
        std.log.info("GLSL version: {s}", .{gl.c.glGetString(gl.c.GL_SHADING_LANGUAGE_VERSION)});
        
        // アルファブレンディングを有効化
        gl.glEnable(gl.GL_BLEND);
        gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA);
        
        return OpenGLContext{
            .context = context,
            .window = window,
        };
    }
    
    pub fn deinit(self: *OpenGLContext) void {
        gl.SDL_GL_DeleteContext(self.context);
        std.log.info("OpenGL context destroyed", .{});
    }
    
    pub fn swapBuffers(self: *OpenGLContext) void {
        gl.SDL_GL_SwapWindow(self.window);
    }
    
    pub fn setViewport(width: i32, height: i32) void {
        gl.glViewport(0, 0, @intCast(width), @intCast(height));
    }
    
    pub fn clearScreen(r: f32, g: f32, b: f32, a: f32) void {
        gl.glClearColor(r, g, b, a);
        gl.glClear(gl.GL_COLOR_BUFFER_BIT | gl.GL_DEPTH_BUFFER_BIT);
    }
};