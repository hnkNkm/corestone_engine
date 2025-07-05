#version 330 core
out vec4 FragColor;

in vec2 TexCoord;

uniform sampler2D sprite_texture;

void main()
{
    FragColor = texture(sprite_texture, TexCoord);
}