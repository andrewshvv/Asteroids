precision mediump float;
precision lowp int;
 
uniform sampler2D   uTexture2D;
 
varying vec2        vTextureCoord;
 
void main()
{
    
    vec4 texColor = texture2D(uTexture2D,vTextureCoord);


    gl_FragColor = texColor;

}