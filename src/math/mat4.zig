const std = @import("std");

pub const Mat4 = struct {
    data: [16]f32,
    
    pub fn identity() Mat4 {
        return Mat4{
            .data = [16]f32{
                1.0, 0.0, 0.0, 0.0,
                0.0, 1.0, 0.0, 0.0,
                0.0, 0.0, 1.0, 0.0,
                0.0, 0.0, 0.0, 1.0,
            },
        };
    }
    
    pub fn ortho(left: f32, right: f32, bottom: f32, top: f32, near: f32, far: f32) Mat4 {
        var result = Mat4{ .data = [_]f32{0.0} ** 16 };
        
        result.data[0] = 2.0 / (right - left);
        result.data[5] = 2.0 / (top - bottom);
        result.data[10] = -2.0 / (far - near);
        result.data[12] = -(right + left) / (right - left);
        result.data[13] = -(top + bottom) / (top - bottom);
        result.data[14] = -(far + near) / (far - near);
        result.data[15] = 1.0;
        
        return result;
    }
    
    pub fn translate(x: f32, y: f32, z: f32) Mat4 {
        var result = identity();
        result.data[12] = x;
        result.data[13] = y;
        result.data[14] = z;
        return result;
    }
    
    pub fn scale(x: f32, y: f32, z: f32) Mat4 {
        var result = identity();
        result.data[0] = x;
        result.data[5] = y;
        result.data[10] = z;
        return result;
    }
    
    pub fn multiply(a: Mat4, b: Mat4) Mat4 {
        var result = Mat4{ .data = [_]f32{0.0} ** 16 };
        
        var i: usize = 0;
        while (i < 4) : (i += 1) {
            var j: usize = 0;
            while (j < 4) : (j += 1) {
                var k: usize = 0;
                while (k < 4) : (k += 1) {
                    result.data[i * 4 + j] += a.data[i * 4 + k] * b.data[k * 4 + j];
                }
            }
        }
        
        return result;
    }
    
    pub fn getPtr(self: *const Mat4) [*]const f32 {
        return &self.data;
    }
};