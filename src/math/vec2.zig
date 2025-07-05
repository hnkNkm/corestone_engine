const std = @import("std");

pub const Vec2 = struct {
    x: f32,
    y: f32,
    
    pub fn new(x: f32, y: f32) Vec2 {
        return Vec2{ .x = x, .y = y };
    }
    
    pub fn zero() Vec2 {
        return Vec2{ .x = 0, .y = 0 };
    }
    
    pub fn add(self: Vec2, other: Vec2) Vec2 {
        return Vec2{
            .x = self.x + other.x,
            .y = self.y + other.y,
        };
    }
    
    pub fn sub(self: Vec2, other: Vec2) Vec2 {
        return Vec2{
            .x = self.x - other.x,
            .y = self.y - other.y,
        };
    }
    
    pub fn scale(self: Vec2, scalar: f32) Vec2 {
        return Vec2{
            .x = self.x * scalar,
            .y = self.y * scalar,
        };
    }
    
    pub fn dot(self: Vec2, other: Vec2) f32 {
        return self.x * other.x + self.y * other.y;
    }
    
    pub fn length(self: Vec2) f32 {
        return @sqrt(self.x * self.x + self.y * self.y);
    }
    
    pub fn normalize(self: Vec2) Vec2 {
        const len = self.length();
        if (len == 0) return self;
        return self.scale(1.0 / len);
    }
};