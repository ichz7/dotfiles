precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    vec4 pix = texture2D(tex, v_texcoord);
    float colorMax = max(pix.r, max(pix.g, pix.b));
    float colorMin = min(pix.r, min(pix.g, pix.b));
    
    // O segredo está aqui: 1.6 deixa as cores bem vivas. 
    // Se ficar muito "neon", mude para 1.3 depois.
    float amount = 1.8; 

    vec3 res = mix(vec3((colorMax + colorMin) * 0.5), pix.rgb, amount);
    gl_FragColor = vec4(res, pix.a);
}
