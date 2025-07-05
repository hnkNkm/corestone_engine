const std = @import("std");
const gl = @import("opengl/gl.zig");
const Texture = @import("opengl/texture.zig").Texture;
const shader = @import("opengl/shader.zig");
const Mat4 = @import("../math/mat4.zig").Mat4;

pub const Sprite = struct {
    texture: *Texture,
    width: f32,
    height: f32,
    
    pub fn init(texture: *Texture) Sprite {
        return Sprite{
            .texture = texture,
            .width = @floatFromInt(texture.width),
            .height = @floatFromInt(texture.height),
        };
    }
};

pub const SpriteRenderer = struct {
    shader_program: shader.ShaderProgram,
    vao: gl.GLuint,
    vbo: gl.GLuint,
    projection: Mat4,
    
    pub fn init(allocator: std.mem.Allocator, screen_width: f32, screen_height: f32) !SpriteRenderer {
        // スプライト用のシェーダーを読み込む
        const program = try shader.ShaderProgram.initFromFiles(
            allocator,
            "assets/shaders/sprite.vert",
            "assets/shaders/sprite.frag"
        );
        
        // スプライト用の頂点データ（四角形、単位座標）
        const vertices = [_]gl.GLfloat{
            // 位置       // テクスチャ座標
            0.0, 0.0,     0.0, 0.0,   // 左上
            1.0, 0.0,     1.0, 0.0,   // 右上
            0.0, 1.0,     0.0, 1.0,   // 左下
            1.0, 0.0,     1.0, 0.0,   // 右上
            1.0, 1.0,     1.0, 1.0,   // 右下
            0.0, 1.0,     0.0, 1.0,   // 左下
        };
        
        var vao: gl.GLuint = 0;
        var vbo: gl.GLuint = 0;
        
        gl.glGenVertexArrays(1, &vao);
        gl.glGenBuffers(1, &vbo);
        
        gl.glBindVertexArray(vao);
        gl.glBindBuffer(gl.GL_ARRAY_BUFFER, vbo);
        gl.glBufferData(gl.GL_ARRAY_BUFFER, @sizeOf(@TypeOf(vertices)), &vertices, gl.GL_STATIC_DRAW);
        
        // 位置属性
        gl.glVertexAttribPointer(0, 2, gl.GL_FLOAT, gl.GL_FALSE, 4 * @sizeOf(gl.GLfloat), null);
        gl.glEnableVertexAttribArray(0);
        
        // テクスチャ座標属性
        gl.glVertexAttribPointer(1, 2, gl.GL_FLOAT, gl.GL_FALSE, 4 * @sizeOf(gl.GLfloat), @ptrFromInt(2 * @sizeOf(gl.GLfloat)));
        gl.glEnableVertexAttribArray(1);
        
        gl.glBindVertexArray(0);
        
        // 2D正投影行列を設定（画面座標系）
        const projection = Mat4.ortho(0.0, screen_width, screen_height, 0.0, -1.0, 1.0);
        
        return SpriteRenderer{
            .shader_program = program,
            .vao = vao,
            .vbo = vbo,
            .projection = projection,
        };
    }
    
    pub fn deinit(self: *SpriteRenderer) void {
        gl.glDeleteVertexArrays(1, &self.vao);
        gl.glDeleteBuffers(1, &self.vbo);
        self.shader_program.deinit();
    }
    
    pub fn drawSprite(self: *const SpriteRenderer, sprite: *const Sprite, x: f32, y: f32, scale: f32) void {
        self.shader_program.use();
        
        // モデル行列を計算（移動・スケール）
        var model = Mat4.identity();
        // 移動
        model.data[12] = x;
        model.data[13] = y;
        // スケール
        model.data[0] = sprite.width * scale;
        model.data[5] = sprite.height * scale;
        
        // Uniform変数を設定
        self.shader_program.setMat4("model", model.getPtr());
        self.shader_program.setMat4("projection", self.projection.getPtr());
        
        // テクスチャをバインド
        Texture.activate(gl.GL_TEXTURE0);
        sprite.texture.bind();
        
        // スプライトを描画
        gl.glBindVertexArray(self.vao);
        gl.glDrawArrays(gl.GL_TRIANGLES, 0, 6);
        gl.glBindVertexArray(0);
    }
};