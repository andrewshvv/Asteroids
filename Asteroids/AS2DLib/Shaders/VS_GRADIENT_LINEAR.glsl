precision mediump float;
precision lowp int;
 
uniform mat4        uProjection;

attribute vec4      aTranslateVector;
attribute float     aAngel;

attribute vec4      aVertexCoord;
attribute vec2      aTextureCoord;

attribute float aStartDegradation;
attribute float aFinishDegradation;

varying vec2  vTextureCoord;

varying float vStartDegradation;
varying float vFinishDegradation;

void main()
{
    vTextureCoord = aTextureCoord;
    vStartDegradation = aStartDegradation;
    vFinishDegradation = aFinishDegradation;

    float cosA = cos(aAngel);
    float sinA = sin(aAngel);
    
    /*
     
        |first| |second| |third| |translateVector|
     
        |   cos(A)  -sin(A)   0        dx    |
    M = |   sin(A)   cos(A)   0        dy    |
        |   0        0        1        dz    |
        |   0        0        0        1     |
     
     */
    vec4 first   = vec4(cosA   ,  sinA , 0.0 , 0.0);
    vec4 second  = vec4(-sinA  ,  cosA , 0.0 , 0.0);
    vec4 third   = vec4(0.0    ,  0.0  , 1.0 , 0.0);
    
    mat4 modelView = mat4(first,second,third,aTranslateVector);
    
    gl_Position =  uProjection * modelView * aVertexCoord;

}