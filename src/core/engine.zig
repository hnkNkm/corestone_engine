const std = @import("std");

pub const EngineError = error{
    // 初期化エラー
    SDLInitFailed,
    OpenGLContextCreationFailed,
    WindowCreationFailed,
    
    // レンダリングエラー
    ShaderCompilationFailed,
    ShaderLinkingFailed,
    TextureLoadFailed,
    
    // リソースエラー
    ResourceNotFound,
    InvalidResourceFormat,
    
    // ECSエラー
    ComponentNotFound,
    EntityNotFound,
    SystemError,
};

pub const Engine = struct {
    allocator: std.mem.Allocator,
    
    pub fn init(allocator: std.mem.Allocator) !Engine {
        return Engine{
            .allocator = allocator,
        };
    }
    
    pub fn deinit(self: *Engine) void {
        _ = self;
    }
};