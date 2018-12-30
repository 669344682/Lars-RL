//
// file: image3D_manual.fx
// version: v1.51
// author: Ren712
//

//--------------------------------------------------------------------------------------
// Settings
//--------------------------------------------------------------------------------------
float3 sElementPosition = float3(0,0,0);
float3 sElementRotation = float3(0,0,0);
float2 sScrRes = float2(800,600);
float2 sElementSize = float2(1,1);
bool sFlipTexture = false;
bool sFlipVertex = false;
bool sIsBillboard = false;
int fCullMode = 1;

float3 sCameraPosition = float3(0,0,0);
float3 sCameraForward = float3(0,0,0);
float3 sCameraUp = float3(0,0,0);
float sFov = 0;
float2 sClip = float2(0.3,300); 
float sFarClipMultiplier = 1;

float2 uvMul = float2(1,1);
float2 uvPos = float2(0,0);

//--------------------------------------------------------------------------------------
// Textures
//--------------------------------------------------------------------------------------
texture sTexColor;

//--------------------------------------------------------------------------------------
// Variables set by MTA
//--------------------------------------------------------------------------------------
int CUSTOMFLAGS < string skipUnusedParameters = "yes"; >;

//--------------------------------------------------------------------------------------
// Sampler 
//--------------------------------------------------------------------------------------
sampler2D SamplerColor = sampler_state
{
    Texture = (sTexColor);
    MipFilter = Linear;
    MagFilter = Linear;
    MinFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};

//--------------------------------------------------------------------------------------
// Structures
//--------------------------------------------------------------------------------------
struct VSInput
{
    float3 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
    float4 Diffuse : COLOR0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
    float4 Diffuse : COLOR0;
};

//--------------------------------------------------------------------------------------
// Create world matrix with world position and euler rotation
//--------------------------------------------------------------------------------------
float4x4 createWorldMatrix(float3 pos, float3 rot)
{
    float4x4 eleMatrix = {
        float4( cos(rot.z) * cos(rot.y) - sin(rot.z) * sin(rot.x) * sin(rot.y), 
                cos(rot.y) * sin(rot.z) + cos(rot.z) * sin(rot.x) * sin(rot.y), -cos(rot.x) * sin(rot.y), 0),
        float4( -cos(rot.x) * sin(rot.z), cos(rot.z) * cos(rot.x), sin(rot.x), 0),
        float4( cos(rot.z) * sin(rot.y) + cos(rot.y) * sin(rot.z) * sin(rot.x), sin(rot.z) * sin(rot.y) - 
                cos(rot.z) * cos(rot.y) * sin(rot.x), cos(rot.x) * cos(rot.y), 0),
        float4( pos.x,pos.y,pos.z, 1),
    };
	return eleMatrix;
}

//--------------------------------------------------------------------------------------
// Create view matrix 
//-------------------------------------------------------------------------------------- 
float4x4 createViewMatrix( float3 pos, float3 fwVec, float3 upVec )
{
    float3 zaxis = normalize( fwVec );    // The "forward" vector.
    float3 xaxis = normalize( cross( -upVec, zaxis ));// The "right" vector.
    float3 yaxis = cross( xaxis, zaxis );     // The "up" vector.

    // Create a 4x4 view matrix from the right, up, forward and eye position vectors
    float4x4 viewMatrix = {
        float4(      xaxis.x,            yaxis.x,            zaxis.x,       0 ),
        float4(      xaxis.y,            yaxis.y,            zaxis.y,       0 ),
        float4(      xaxis.z,            yaxis.z,            zaxis.z,       0 ),
        float4(-dot( xaxis, pos ), -dot( yaxis, pos ), -dot( zaxis, pos ),  1 )
    };
    return viewMatrix;
}

//--------------------------------------------------------------------------------------
// Create projection matrix 
//--------------------------------------------------------------------------------------
float4x4 createProjectionMatrix(float near_plane, float far_plane, float fov_horiz, float fov_aspect)
{
    float h, w, Q;

    w = 1/tan(fov_horiz * 0.5);
    h = w / fov_aspect;
    Q = far_plane/(far_plane - near_plane);

    float4x4 projectionMatrix = {
        float4(      w,            0,        0,             0 ),
        float4(      0,            h,        0,             0 ),
        float4(      0,            0,        Q,             1 ),
        float4(      0,            0,        -Q*near_plane, 0 )
    };    
    return projectionMatrix;
}

//--------------------------------------------------------------------------------------
// Vertex Shader 
//--------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
	
    // set proper position and scale of the quad
    VS.Position.xy /= float2( sScrRes.x, sScrRes.y );
    VS.Position.xy = - 0.5 + VS.Position.xy;
    VS.Position.xy *= sElementSize.xy;
    if (!sFlipTexture) VS.TexCoord.y = 1 - VS.TexCoord.y;
    if (sFlipVertex) VS.Position.xyz = VS.Position.xzy;
	
    // create WorldMatrix for the quad
    float4x4 sWorld = createWorldMatrix(sElementPosition, sElementRotation);

    // create ViewMatrix from cameraPosition and fw vector
    float4x4 sView = createViewMatrix(sCameraPosition, sCameraForward, sCameraUp);

    // create ProjectionMatrix
    float sAspect = (sScrRes.y / sScrRes.x);
    float4x4 sProjection = createProjectionMatrix(sClip[0], sClip[1] * sFarClipMultiplier, sFov, sAspect);
	
    // calculate screen position of the vertex
    if (sIsBillboard) 
    {
        float4x4 sWorldView = mul(sWorld, sView);
        float3 positionVS = VS.Position.xyz + sWorldView[3].xyz;
        PS.Position = mul(float4(positionVS, 1), sProjection);
    }
    else
    {
        float4 wPos = mul(float4(VS.Position, 1), sWorld);
        float4 vPos = mul(wPos, sView); 
        PS.Position = mul(vPos, sProjection);
    }

    // pass texCoords and vertex color to PS
    PS.TexCoord = (VS.TexCoord * uvMul) + uvPos;
    PS.Diffuse = VS.Diffuse;
	
    return PS;
}

//--------------------------------------------------------------------------------------
// Pixel shaders 
//--------------------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    // sample color texture
    float4 finalColor = tex2D(SamplerColor, PS.TexCoord.xy);
	
    // multiply by vertex color
    finalColor *= PS.Diffuse;

    return saturate(finalColor);
}

//--------------------------------------------------------------------------------------
// Techniques
//--------------------------------------------------------------------------------------
technique dxDrawImage3DMan
{
  pass P0
  {
    ZEnable = false;
    CullMode = fCullMode;
    ShadeMode = Gouraud;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaRef = 1;
    AlphaFunc = GreaterEqual;
    Lighting = false;
    FogEnable = false;
    VertexShader = compile vs_2_0 VertexShaderFunction();
    PixelShader  = compile ps_2_0 PixelShaderFunction();
  }
} 
	