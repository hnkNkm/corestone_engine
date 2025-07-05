const std = @import("std");
const gl = @import("gl.zig");

// 単純なBMP画像ローダー（ヘッダーなし、raw RGBデータ）
fn loadRawRGB(allocator: std.mem.Allocator, file_path: []const u8, width: u32, height: u32) ![]u8 {
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();
    
    const size = width * height * 3; // RGB
    const data = try allocator.alloc(u8, size);
    _ = try file.read(data);
    
    return data;
}

pub const Texture = struct {
    id: gl.GLuint,
    width: i32,
    height: i32,
    
    pub fn init() !Texture {
        var texture_id: gl.GLuint = 0;
        gl.glGenTextures(1, &texture_id);
        
        if (texture_id == 0) {
            return error.TextureCreationFailed;
        }
        
        return Texture{
            .id = texture_id,
            .width = 0,
            .height = 0,
        };
    }
    
    pub fn deinit(self: *Texture) void {
        gl.glDeleteTextures(1, &self.id);
    }
    
    pub fn bind(self: *const Texture) void {
        gl.glBindTexture(gl.GL_TEXTURE_2D, self.id);
    }
    
    pub fn unbind() void {
        gl.glBindTexture(gl.GL_TEXTURE_2D, 0);
    }
    
    // 生のRGBデータからテクスチャを作成
    pub fn loadFromData(self: *Texture, data: []const u8, width: i32, height: i32, format: gl.GLenum) !void {
        self.width = width;
        self.height = height;
        
        // テクスチャをバインド
        self.bind();
        
        // テクスチャパラメータを設定
        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_S, @intCast(gl.GL_REPEAT));
        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_T, @intCast(gl.GL_REPEAT));
        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, @intCast(gl.GL_LINEAR));
        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, @intCast(gl.GL_LINEAR));
        
        // テクスチャデータをGPUに転送
        gl.glTexImage2D(
            gl.GL_TEXTURE_2D,
            0,
            @intCast(format),
            self.width,
            self.height,
            0,
            format,
            gl.GL_UNSIGNED_BYTE,
            data.ptr
        );
        
        unbind();
        
        std.log.info("Created texture: {}x{}", .{ self.width, self.height });
    }
    
    // プログラムで生成したテスト用のチェッカーボードテクスチャ
    pub fn createCheckerboard(self: *Texture, allocator: std.mem.Allocator, size: u32) !void {
        const width = size;
        const height = size;
        const data = try allocator.alloc(u8, width * height * 4);
        defer allocator.free(data);
        
        // チェッカーボードパターンを生成
        var y: u32 = 0;
        while (y < height) : (y += 1) {
            var x: u32 = 0;
            while (x < width) : (x += 1) {
                const idx = (y * width + x) * 4;
                const checker = ((x / 16) + (y / 16)) % 2;
                if (checker == 0) {
                    data[idx] = 255;     // R
                    data[idx + 1] = 0;   // G
                    data[idx + 2] = 0;   // B
                    data[idx + 3] = 255; // A
                } else {
                    data[idx] = 0;       // R
                    data[idx + 1] = 0;   // G
                    data[idx + 2] = 255; // B
                    data[idx + 3] = 255; // A
                }
            }
        }
        
        try self.loadFromData(data, @intCast(width), @intCast(height), gl.GL_RGBA);
        std.log.info("Created checkerboard texture: {}x{}", .{ width, height });
    }
    
    pub fn activate(texture_unit: gl.GLenum) void {
        gl.glActiveTexture(texture_unit);
    }
};