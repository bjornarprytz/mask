shader_type canvas_item;

uniform float ripple_frequency: hint_range(1.0, 20.0, 0.1) = 5.0;
uniform float ripple_noise: hint_range(0.0, 1.0, 0.01) = 0.2;
uniform float ripple_speed: hint_range(0.1, 5.0, 0.1) = 1.0;
uniform float ripple_strength: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float ripple_width: hint_range(0.01, 1.0, 0.01) = 0.1;
uniform float ripple_transparency: hint_range(0.0, 1.0, 0.01) = 1.0;

// Simple noise function
float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    
    // Calculate distance from center
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);
    
    // Add noise to the distance for wavy ripples
    float noise_value = noise(UV * 10.0 + TIME) * 2.0 - 1.0;
    dist += noise_value * ripple_noise * 0.1;
    
    // Create ripple pattern with width control
    float ripple_phase = (dist * ripple_frequency - TIME * ripple_speed) * 6.28318;
    float ripple = sin(ripple_phase);
    
    // Create sharp ripple bands based on width
    float ripple_band = smoothstep(1.0 - ripple_width, 1.0, abs(ripple));
    
    // Apply ripple to alpha with transparency control
    float effect = mix(1.0, ripple_band, ripple_strength);
    
    color.a *= effect * ripple_transparency;
    
    COLOR = color;
}
