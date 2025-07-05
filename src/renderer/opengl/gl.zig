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

// エラーコード
pub const GL_NO_ERROR = 0;
pub const GL_INVALID_ENUM = 0x0500;
pub const GL_INVALID_VALUE = 0x0501;
pub const GL_INVALID_OPERATION = 0x0502;
pub const GL_STACK_OVERFLOW = 0x0503;
pub const GL_STACK_UNDERFLOW = 0x0504;
pub const GL_OUT_OF_MEMORY = 0x0505;
pub const GL_INVALID_FRAMEBUFFER_OPERATION = 0x0506;

// 情報取得用定数
pub const GL_VENDOR = 0x1F00;
pub const GL_RENDERER = 0x1F01;
pub const GL_VERSION = 0x1F02;
pub const GL_SHADING_LANGUAGE_VERSION = 0x8B8C;
pub const GL_VIEWPORT = 0x0BA2;

// テクスチャ関連の定数
pub const GL_TEXTURE_2D = 0x0DE1;
pub const GL_TEXTURE0 = 0x84C0;
pub const GL_TEXTURE_WRAP_S = 0x2802;
pub const GL_TEXTURE_WRAP_T = 0x2803;
pub const GL_TEXTURE_MIN_FILTER = 0x2801;
pub const GL_TEXTURE_MAG_FILTER = 0x2800;
pub const GL_REPEAT = 0x2901;
pub const GL_LINEAR = 0x2601;
pub const GL_RGB = 0x1907;
pub const GL_RGBA = 0x1908;
pub const GL_UNSIGNED_BYTE = c.GL_UNSIGNED_BYTE;
pub const GL_BLEND = 0x0BE2;
pub const GL_SRC_ALPHA = 0x0302;
pub const GL_ONE_MINUS_SRC_ALPHA = 0x0303;

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

// テクスチャ関連の関数
pub var glGenTextures: *const fn (n: GLsizei, textures: [*c]GLuint) callconv(.C) void = undefined;
pub var glBindTexture: *const fn (target: GLenum, texture: GLuint) callconv(.C) void = undefined;
pub var glTexParameteri: *const fn (target: GLenum, pname: GLenum, param: GLint) callconv(.C) void = undefined;
pub var glTexImage2D: *const fn (target: GLenum, level: GLint, internalformat: GLint, width: GLsizei, height: GLsizei, border: GLint, format: GLenum, type: GLenum, pixels: ?*const anyopaque) callconv(.C) void = undefined;
pub var glActiveTexture: *const fn (texture: GLenum) callconv(.C) void = undefined;
pub var glDeleteTextures: *const fn (n: GLsizei, textures: [*c]const GLuint) callconv(.C) void = undefined;
pub var glGetUniformLocation: *const fn (program: GLuint, name: [*c]const GLchar) callconv(.C) GLint = undefined;
pub var glUniform1i: *const fn (location: GLint, v0: GLint) callconv(.C) void = undefined;
pub var glUniform3f: *const fn (location: GLint, v0: GLfloat, v1: GLfloat, v2: GLfloat) callconv(.C) void = undefined;
pub var glUniformMatrix4fv: *const fn (location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) callconv(.C) void = undefined;
pub var glEnable: *const fn (cap: GLenum) callconv(.C) void = undefined;
pub var glBlendFunc: *const fn (sfactor: GLenum, dfactor: GLenum) callconv(.C) void = undefined;
pub var glGetString: *const fn (name: GLenum) callconv(.C) [*c]const u8 = undefined;
pub var glGetIntegerv: *const fn (pname: GLenum, params: [*c]GLint) callconv(.C) void = undefined;

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
    
    // テクスチャ関連の関数を初期化
    glGenTextures = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glGenTextures") orelse return error.OpenGLFunctionNotFound));
    glBindTexture = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glBindTexture") orelse return error.OpenGLFunctionNotFound));
    glTexParameteri = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glTexParameteri") orelse return error.OpenGLFunctionNotFound));
    glTexImage2D = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glTexImage2D") orelse return error.OpenGLFunctionNotFound));
    glActiveTexture = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glActiveTexture") orelse return error.OpenGLFunctionNotFound));
    glDeleteTextures = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glDeleteTextures") orelse return error.OpenGLFunctionNotFound));
    glGetUniformLocation = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glGetUniformLocation") orelse return error.OpenGLFunctionNotFound));
    glUniform1i = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glUniform1i") orelse return error.OpenGLFunctionNotFound));
    glUniform3f = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glUniform3f") orelse return error.OpenGLFunctionNotFound));
    glUniformMatrix4fv = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glUniformMatrix4fv") orelse return error.OpenGLFunctionNotFound));
    glEnable = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glEnable") orelse return error.OpenGLFunctionNotFound));
    glBlendFunc = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glBlendFunc") orelse return error.OpenGLFunctionNotFound));
    glGetString = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glGetString") orelse return error.OpenGLFunctionNotFound));
    glGetIntegerv = @ptrCast(@alignCast(SDL_GL_GetProcAddress("glGetIntegerv") orelse return error.OpenGLFunctionNotFound));
    
    std.log.info("OpenGL functions loaded successfully", .{});
}