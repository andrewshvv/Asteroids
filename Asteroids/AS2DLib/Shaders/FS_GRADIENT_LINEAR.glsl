precision mediump float;
precision lowp int;

uniform sampler2D   uTexture2D;

varying vec2  vTextureCoord;

varying float vStartDegradation;
varying float vFinishDegradation;

void main()
{
    float k =  (- 1.0) / (vFinishDegradation - vStartDegradation);
    float m = 1.0 - k*vStartDegradation;
    float func = k * vTextureCoord.s  +  m;
    
    float resAlpha =  clamp(func ,0.0,1.0);
    
    vec4 texColor = texture2D(uTexture2D, vTextureCoord);
    gl_FragColor =  vec4(texColor.rgb ,resAlpha);
    


}