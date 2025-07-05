const std = @import("std");
const gl = @import("gl.zig");

pub const ShaderType = enum {
    vertex,
    fragment,
    
    pub fn toGL(self: ShaderType) gl.GLenum {
        return switch (self) {
            .vertex => gl.GL_VERTEX_SHADER,
            .fragment => gl.GL_FRAGMENT_SHADER,
        };
    }
};

pub const Shader = struct {
    id: gl.GLuint,
    shader_type: ShaderType,
    
    pub fn init(source: []const u8, shader_type: ShaderType) !Shader {
        const shader_id = gl.glCreateShader(shader_type.toGL());
        if (shader_id == 0) {
            std.log.err("Failed to create shader", .{});
            return error.ShaderCreationFailed;
        }
        
        // シェーダーソースを設定
        const source_ptr: [*c]const u8 = source.ptr;
        const source_len: gl.GLint = @intCast(source.len);
        gl.glShaderSource(shader_id, 1, &source_ptr, &source_len);
        
        // シェーダーをコンパイル
        gl.glCompileShader(shader_id);
        
        // コンパイル結果を確認
        var compile_status: gl.GLint = 0;
        gl.glGetShaderiv(shader_id, gl.GL_COMPILE_STATUS, &compile_status);
        
        if (compile_status == gl.GL_FALSE) {
            var info_log_length: gl.GLint = 0;
            gl.glGetShaderiv(shader_id, gl.GL_INFO_LOG_LENGTH, &info_log_length);
            
            if (info_log_length > 0) {
                var info_log = std.ArrayList(u8).init(std.heap.page_allocator);
                defer info_log.deinit();
                
                try info_log.resize(@intCast(info_log_length));
                gl.glGetShaderInfoLog(shader_id, info_log_length, null, info_log.items.ptr);
                
                std.log.err("Shader compilation failed: {s}", .{info_log.items});
            }
            
            gl.glDeleteShader(shader_id);
            return error.ShaderCompilationFailed;
        }
        
        std.log.info("Shader compiled successfully (type: {})", .{shader_type});
        return Shader{
            .id = shader_id,
            .shader_type = shader_type,
        };
    }
    
    pub fn deinit(self: *Shader) void {
        gl.glDeleteShader(self.id);
    }
    
    pub fn initFromFile(allocator: std.mem.Allocator, file_path: []const u8, shader_type: ShaderType) !Shader {
        const file = try std.fs.cwd().openFile(file_path, .{});
        defer file.close();
        
        const file_size = try file.getEndPos();
        const source = try allocator.alloc(u8, file_size);
        defer allocator.free(source);
        
        _ = try file.read(source);
        
        std.log.info("Loaded shader from file: {s} ({} bytes)", .{ file_path, file_size });
        
        return init(source, shader_type);
    }
};

pub const ShaderProgram = struct {
    id: gl.GLuint,
    
    pub fn init(vertex_shader: *const Shader, fragment_shader: *const Shader) !ShaderProgram {
        const program_id = gl.glCreateProgram();
        if (program_id == 0) {
            std.log.err("Failed to create shader program", .{});
            return error.ShaderProgramCreationFailed;
        }
        
        // シェーダーをアタッチ
        gl.glAttachShader(program_id, vertex_shader.id);
        gl.glAttachShader(program_id, fragment_shader.id);
        
        // プログラムをリンク
        gl.glLinkProgram(program_id);
        
        // リンク結果を確認
        var link_status: gl.GLint = 0;
        gl.glGetProgramiv(program_id, gl.GL_LINK_STATUS, &link_status);
        
        if (link_status == gl.GL_FALSE) {
            var info_log_length: gl.GLint = 0;
            gl.glGetProgramiv(program_id, gl.GL_INFO_LOG_LENGTH, &info_log_length);
            
            if (info_log_length > 0) {
                var info_log = std.ArrayList(u8).init(std.heap.page_allocator);
                defer info_log.deinit();
                
                try info_log.resize(@intCast(info_log_length));
                gl.glGetProgramInfoLog(program_id, info_log_length, null, info_log.items.ptr);
                
                std.log.err("Shader program linking failed: {s}", .{info_log.items});
            }
            
            gl.glDeleteProgram(program_id);
            return error.ShaderLinkingFailed;
        }
        
        return ShaderProgram{
            .id = program_id,
        };
    }
    
    pub fn deinit(self: *ShaderProgram) void {
        gl.glDeleteProgram(self.id);
    }
    
    pub fn use(self: *const ShaderProgram) void {
        gl.glUseProgram(self.id);
    }
    
    pub fn setMat4(self: *const ShaderProgram, name: [*c]const u8, value: [*]const f32) void {
        const location = gl.glGetUniformLocation(self.id, name);
        gl.glUniformMatrix4fv(location, 1, gl.GL_FALSE, value);
    }
    
    pub fn setVec3(self: *const ShaderProgram, name: [*c]const u8, x: f32, y: f32, z: f32) void {
        const location = gl.glGetUniformLocation(self.id, name);
        gl.glUniform3f(location, x, y, z);
    }
    
    pub fn setInt(self: *const ShaderProgram, name: [*c]const u8, value: i32) void {
        const location = gl.glGetUniformLocation(self.id, name);
        gl.glUniform1i(location, value);
    }
    
    pub fn initFromFiles(allocator: std.mem.Allocator, vertex_path: []const u8, fragment_path: []const u8) !ShaderProgram {
        var vertex_shader = try Shader.initFromFile(allocator, vertex_path, .vertex);
        defer vertex_shader.deinit();
        
        var fragment_shader = try Shader.initFromFile(allocator, fragment_path, .fragment);
        defer fragment_shader.deinit();
        
        return init(&vertex_shader, &fragment_shader);
    }
};

// 基本的なシェーダーソース
pub const basic_vertex_shader =
    \\#version 330 core
    \\layout (location = 0) in vec3 aPos;
    \\
    \\void main()
    \\{
    \\    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
    \\}
;

pub const basic_fragment_shader =
    \\#version 330 core
    \\out vec4 FragColor;
    \\
    \\void main()
    \\{
    \\    FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
    \\}
;