shader_type canvas_item;

uniform vec4 outline_color = vec4(1.0);
uniform float outline_thickness = 8.0;
uniform float corner_radius = 32.0;

void fragment() {
    vec2 size = vec2(textureSize(TEXTURE, 0));
    vec2 uv_px = UV * size;

    float left   = outline_thickness;
    float right  = size.x - outline_thickness;
    float top    = outline_thickness;
    float bottom = size.y - outline_thickness;

    float r = corner_radius;

    bool is_border = (
        uv_px.x < left || uv_px.x > right ||
        uv_px.y < top || uv_px.y > bottom
    );

    vec2 center = vec2(
        clamp(uv_px.x, r, size.x - r),
        clamp(uv_px.y, r, size.y - r)
    );
    float dist = distance(uv_px, center);

    if (is_border && dist <= r) {
        COLOR = outline_color;
    } else {
        COLOR = texture(TEXTURE, UV);
    }
}
