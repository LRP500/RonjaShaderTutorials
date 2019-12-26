// https://www.ronja-tutorials.com/2018/07/08/postprocessing-normal.html

Shader "Tutorials/17_PostProcessingNormal"
{
    Properties
    {
        [HideInInspector] _MainTex("Texture", 2D) = "white" {}
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

            float4x4 _viewToWorld;

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

            fixed4 frag(v2f i) : SV_TARGET
            {
                float4 depthNormal = tex2D(_CameraDepthNormalsTexture, i.uv);

                // decode depth & normal
                float depth;
                float3 normal;
                DecodeDepthNormal(depthNormal, depth, normal);

                // get depth as distance from camera in units
                depth = depth * _ProjectionParams.z;

                normal = mul((float3x3)_viewToWorld, normal);

                return float4(normal, 1);
            }

            ENDCG
        }
    }
}
