const std = @import("std");

// OpenGL/SDL2ヘッダーをインポート
pub const c = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_opengl.h");
});

// OpenGLのタイプエイリアス
pub const GLuint = c.GLuint;
pub const GLint = c.GLint;
pub const GLfloat = c.GLfloat;
pub const GLsizei = c.GLsizei;
pub const GLboolean = c.GLboolean;
pub const GLchar = c.GLchar;
pub const GLenum = c.GLenum;
pub const GLvoid = anyopaque;
pub const GLbitfield = c.GLbitfield;

// OpenGL定数
pub const GL_FALSE = c.GL_FALSE;
pub const GL_TRUE = c.GL_TRUE;
pub const GL_TRIANGLES = c.GL_TRIANGLES;
pub const GL_UNSIGNED_INT = c.GL_UNSIGNED_INT;
pub const GL_FLOAT = c.GL_FLOAT;
pub const GL_VERTEX_SHADER = 0x8B31;
pub const GL_FRAGMENT_SHADER = 0x8B30;
pub const GL_COMPILE_STATUS = 0x8B81;
pub const GL_LINK_STATUS = 0x8B82;
pub const GL_INFO_LOG_LENGTH = 0x8B84;
pub const GL_ARRAY_BUFFER = 0x8892;
pub const GL_STATIC_DRAW = 0x88E4;
pub const GL_COLOR_BUFFER_BIT = c.GL_COLOR_BUFFER_BIT;
pub const GL_DEPTH_BUFFER_BIT = c.GL_DEPTH_BUFFER_BIT;

// SDL_GL関数
pub const SDL_GL_CreateContext = c.SDL_GL_CreateContext;
pub const SDL_GL_DeleteContext = c.SDL_GL_DeleteContext;
pub const SDL_GL_SetAttribute = c.SDL_GL_SetAttribute;
pub const SDL_GL_SwapWindow = c.SDL_GL_SwapWindow;
pub const SDL_GL_MakeCurrent = c.SDL_GL_MakeCurrent;
pub const SDL_GL_GetProcAddress = c.SDL_GL_GetProcAddress;

// SDL_GL属性
pub const SDL_GL_CONTEXT_MAJOR_VERSION = c.SDL_GL_CONTEXT_MAJOR_VERSION;
pub const SDL_GL_CONTEXT_MINOR_VERSION = c.SDL_GL_CONTEXT_MINOR_VERSION;
pub const SDL_GL_CONTEXT_PROFILE_MASK = c.SDL_GL_CONTEXT_PROFILE_MASK;
pub const SDL_GL_CONTEXT_PROFILE_CORE = c.SDL_GL_CONTEXT_PROFILE_CORE;
pub const SDL_GL_DOUBLEBUFFER = c.SDL_GL_DOUBLEBUFFER;

// OpenGL関数ポインタ
pub var glClearColor: *const fn (r: GLfloat, g: GLfloat, b: GLfloat, a: GLfloat) callconv(.C) void = undefined;
pub var glClear: *const fn (mask: GLbitfield) callconv(.C) void = undefined;
pub var glViewport: *const fn (x: GLint, y: GLint, width: GLsizei, height: GLsizei) callconv(.C) void = undefined;
pub var glCreateShader: *const fn (shader_type: GLenum) callconv(.C) GLuint = undefined;
pub var glShaderSource: *const fn (shader: GLuint, count: GLsizei, string: [*c]const [*c]const u8, length: [*c]const GLint) callconv(.C) void = undefined;
pub var glCompileShader: *const fn (shader: GLuint) callconv(.C) void = undefined;
pub var glGetShaderiv: *const fn (shader: GLuint, pname: GLenum, params: [*c]GLint) callconv(.C) void = undefined;
pub var glGetShaderInfoLog: *const fn (shader: GLuint, maxLength: GLsizei, length: [*c]GLsizei, infoLog: [*c]GLchar) callconv(.C) void = undefined;
pub var glDeleteShader: *const fn (shader: GLuint) callconv(.C) void = undefined;
pub var glCreateProgram: *const fn () callconv(.C) GLuint = undefined;
pub var glAttachShader: *const fn (program: GLuint, shader: GLuint) callconv(.C) void = undefined;
pub var glLinkProgram: *const fn (program: GLuint) callconv(.C) void = undefined;
pub var glGetProgramiv: *const fn (program: GLuint, pname: GLenum, params: [*c]GLint) callconv(.C) void = undefined;
pub var glGetProgramInfoLog: *const fn (program: GLuint, maxLength: GLsizei, length: [*c]GLsizei, infoLog: [*c]GLchar) callconv(.C) void = undefined;
pub var glDeleteProgram: *const fn (program: GLuint) callconv(.C) void = undefined;
pub var glUseProgram: *const fn (program: GLuint) callconv(.C) void = undefined;
pub var glGenVertexArrays: *const fn (n: GLsizei, arrays: [*c]GLuint) callconv(.C) void = undefined;
pub var glGenBuffers: *const fn (n: GLsizei, buffers: [*c]GLuint) callconv(.C) void = undefined;
pub var glBindVertexArray: *const fn (array: GLuint) callconv(.C) void = undefined;
pub var glBindBuffer: *const fn (target: GLenum, buffer: GLuint) callconv(.C) void = undefined;
pub var glBufferData: *const fn (target: GLenum, size: isize, data: ?*const anyopaque, usage: GLenum) callconv(.C) void = undefined;
pub var glVertexAttribPointer: *const fn (index: GLuint, size: GLint, type: GLenum, normalized: GLboolean, stride: GLsizei, pointer: ?*const anyopaque) callconv(.C) void = undefined;
pub var glEnableVertexAttribArray: *const fn (index: GLuint) callconv(.C) void = undefined;
pub var glDrawArrays: *const fn (mode: GLenum, first: GLint, count: GLsizei) callconv(.C) void = undefined;
pub var glGetError: *const fn () callconv(.C) GLenum = undefined;
pub var glDeleteVertexArrays: *const fn (n: GLsizei, arrays: [*c]const GLuint) callconv(.C) void = undefined;
pub var glDeleteBuffers: *const fn (n: GLsizei, buffers: [*c]const GLuint) callconv(.C) void = undefined;

// OpenGL関数を初期化
pub fn init() !void {
    glClearColor = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glClearColor") orelse return error.OpenGLFunctionNotFound));
    glClear = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glClear") orelse return error.OpenGLFunctionNotFound));
    glViewport = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glViewport") orelse return error.OpenGLFunctionNotFound));
    glCreateShader = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glCreateShader") orelse return error.OpenGLFunctionNotFound));
    glShaderSource = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glShaderSource") orelse return error.OpenGLFunctionNotFound));
    glCompileShader = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glCompileShader") orelse return error.OpenGLFunctionNotFound));
    glGetShaderiv = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glGetShaderiv") orelse return error.OpenGLFunctionNotFound));
    glGetShaderInfoLog = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glGetShaderInfoLog") orelse return error.OpenGLFunctionNotFound));
    glDeleteShader = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glDeleteShader") orelse return error.OpenGLFunctionNotFound));
    glCreateProgram = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glCreateProgram") orelse return error.OpenGLFunctionNotFound));
    glAttachShader = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glAttachShader") orelse return error.OpenGLFunctionNotFound));
    glLinkProgram = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glLinkProgram") orelse return error.OpenGLFunctionNotFound));
    glGetProgramiv = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glGetProgramiv") orelse return error.OpenGLFunctionNotFound));
    glGetProgramInfoLog = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glGetProgramInfoLog") orelse return error.OpenGLFunctionNotFound));
    glDeleteProgram = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glDeleteProgram") orelse return error.OpenGLFunctionNotFound));
    glUseProgram = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glUseProgram") orelse return error.OpenGLFunctionNotFound));
    glGenVertexArrays = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glGenVertexArrays") orelse return error.OpenGLFunctionNotFound));
    glGenBuffers = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glGenBuffers") orelse return error.OpenGLFunctionNotFound));
    glBindVertexArray = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glBindVertexArray") orelse return error.OpenGLFunctionNotFound));
    glBindBuffer = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glBindBuffer") orelse return error.OpenGLFunctionNotFound));
    glBufferData = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glBufferData") orelse return error.OpenGLFunctionNotFound));
    glVertexAttribPointer = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glVertexAttribPointer") orelse return error.OpenGLFunctionNotFound));
    glEnableVertexAttribArray = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glEnableVertexAttribArray") orelse return error.OpenGLFunctionNotFound));
    glDrawArrays = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glDrawArrays") orelse return error.OpenGLFunctionNotFound));
    glGetError = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glGetError") orelse return error.OpenGLFunctionNotFound));
    glDeleteVertexArrays = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glDeleteVertexArrays") orelse return error.OpenGLFunctionNotFound));
    glDeleteBuffers = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glDeleteBuffers") orelse return error.OpenGLFunctionNotFound));
    
    std.log.info("OpenGL functions loaded successfully", .{});
}