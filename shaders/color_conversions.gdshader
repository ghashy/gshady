shader_type canvas_item;


//  Function from Iñigo Quiles
//  https://www.shadertoy.com/view/MsS3Wc
vec3 hsv2rgb_complicated( in vec3 uv ){
	vec3 tones = mod(uv.x*6.0+vec3(0.0,4.0,2.0),6.0); // x 0.5 => 3,1,2 
    vec3 rgb = clamp(abs(tones-3.0)-1.0,0.0,1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return uv.z * mix(vec3(1.0), rgb, uv.y);
}

vec3 rgb2hsb( in vec3 c ){
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz),
                 vec4(c.gb, K.xy),
                 step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r),
                 vec4(c.r, p.yzx),
                 step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10; // not sure this notation will work in godot
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)),
                d / (q.x + e),
                q.x);
}

vec3 hue2rgb(float hue) {
    float r = abs(hue * 6.0 - 3.0) - 1.0; //red
    float g = 2.0 - abs(hue * 6.0 - 2.0); //green
    float b = 2.0 - abs(hue * 6.0 - 4.0); //blue
    vec3 rgb = vec3(r,g,b); //combine components
    rgb = clamp(rgb, 0.0, 1.0); //clamp between 0 and 1
    return rgb;
}

vec3 hsv2rgb(vec3 hsv)
{
    vec3 rgb = hue2rgb(hsv.x); //apply hue
    rgb = mix(vec3(1.0), rgb, hsv.y); //apply saturation
    rgb = rgb * hsv.z; //apply value
    return rgb;
}

void fragment(){
    vec2 uv = UV;
    vec3 color = vec3(0.0);

    // We map x (0.0 - 1.0) to the hue (0.0 - 1.0)
    // And the y (0.0 - 1.0) to the brightness
    color = hsv2rgb(vec3(uv.x,1.0,uv.y));

    COLOR = vec4(color,1.0);
}

