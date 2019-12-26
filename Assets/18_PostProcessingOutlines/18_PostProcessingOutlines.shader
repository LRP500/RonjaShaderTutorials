// https://www.ronja-tutorials.com/2018/07/15/postprocessing-outlines.html

Shader "Tutorials/18_PostProcessingOutlines"
{
    Properties
    {
        [HideInInspector] _MainTex("Texture", 2D) = "white" {}
        _NormalMult("Normal Outline Multiplier", Range(0, 4)) = 1
        _NormalBias("Normal Outline Bias", Range(1, 4)) = 1
        _DepthMult("Depth Outline Multiplier", Range(0, 4)) = 1
        _DepthBias("Depth Outline Bias", Range(1, 4)) = 1
        _OutlineColor("Outline Color", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Cull off
        ZWrite off
        ZTest Always

        Pass
        {
            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;
            sampler2D _CameraDepthNormalsTexture;

            // texelsize represents the size of a pixel in the texture
            float4 _CameraDepthNormalsTexture_TexelSize;

            float _NormalMult;
            float _NormalBias;
            float _DepthMult;
            float _DepthBias;

            float4 _OutlineColor;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            void Compare(inout float depthOutline, inout float3 normalOutline, float baseDepth, float3 baseNormal, float2 uv, float2 offset)
            {
                float4 neighborDepthNormal = tex2D(_CameraDepthNormalsTexture, uv + _CameraDepthNormalsTexture_TexelSize.xy * offset);

                float neighborDepth;
                float3 neighborNormal;
                DecodeDepthNormal(neighborDepthNormal, neighborDepth, neighborNormal);

                neighborDepth = neighborDepth * _ProjectionParams.z;

                // calculate depth difference
                float depthDifference = baseDepth - neighborDepth;
                depthOutline = depthOutline + depthDifference;

                // calculate normal difference
                float3 normalDifference = baseNormal - neighborNormal;
                normalDifference = normalDifference.r + normalDifference.g + normalDifference.b; 
                normalOutline = normalOutline + normalDifference;
            } 

            fixed4 frag(v2f i) : SV_TARGET
            {
                float4 depthNormal = tex2D(_CameraDepthNormalsTexture, i.uv);

                // decode depth & normal
                float depth;
                float3 normal;
                DecodeDepthNormal(depthNormal, depth, normal);

                // get depth as distance from camera in units
                depth = depth * _ProjectionParams.z;

                float depthDifference = 0;
                float3 normalDifference = 0;
                Compare(depthDifference, normalDifference, depth, normal, i.uv, float2(1, 0));
                Compare(depthDifference, normalDifference, depth, normal, i.uv, float2(0, 1));
                Compare(depthDifference, normalDifference, depth, normal, i.uv, float2(-1, 0));
                Compare(depthDifference, normalDifference, depth, normal, i.uv, float2(0, -1));

                // apply mutliplier and bias to depth outline
                depthDifference = depthDifference * _DepthMult;
                depthDifference = saturate(depthDifference);
                depthDifference = pow(depthDifference, _DepthBias);

                // apply mutliplier and bias to depth outline
                normalDifference = normalDifference * _NormalMult;
                normalDifference = saturate(normalDifference);
                normalDifference = pow(normalDifference, _NormalBias);

                // apply outline color
                float outline = depthDifference + normalDifference;
                float4 sourceColor = tex2D(_MainTex, i.uv); 
                float4 color = lerp(sourceColor, _OutlineColor, outline);

                return color;
            }

            ENDCG
        }
    }
}
