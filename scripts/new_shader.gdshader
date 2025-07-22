shader_type canvas_item;

uniform sampler2D mask;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec4 mask_color = texture(mask, UV);

    if (mask_color.a < 0.5) {
        discard; // Esconde o pixel
    }

    COLOR = tex_color;
}
