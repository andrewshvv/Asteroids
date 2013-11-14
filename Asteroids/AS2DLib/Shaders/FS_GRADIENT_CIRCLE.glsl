precision mediump float;
precision lowp int;

uniform sampler2D   uTexture2D;

varying vec2  vTextureCoord;


varying float vStartRadius;
varying float vFinishRadius;

varying float vAlpha;

varying vec2  vCenterVector;
varying float vCoefficient;


void main()
{
    float k =  (- 1.0) / (vFinishRadius - vStartRadius);
    float m = 1.0 - k * vStartRadius;
    
    float r = sqrt(pow(abs(vTextureCoord.s - vCenterVector.s),2.0) + pow(abs(vCoefficient*(vTextureCoord.t - vCenterVector.t)),2.0));
    float func = k * r  +  m;


    float resAlpha = vAlpha * clamp(func,0.0,1.0);
    
    vec4 texColor = texture2D(uTexture2D, vTextureCoord);
    gl_FragColor =  vec4(texColor.rgb ,resAlpha);
        


}
    