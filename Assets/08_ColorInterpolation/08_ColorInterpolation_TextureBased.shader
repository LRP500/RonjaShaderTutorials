// https://www.ronja-tutorials.com/2018/03/23/textures.html

Shader "Tutorials/08_ColorInterpolation"
{
    // ShaderLab: Properties
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _SecondaryTex("Secondary Texture", 2D) = "white" {}
        // _Color("Color", Color) = (0, 0, 0, 1)
        // _SecondaryColor("Secondary Color", Color) = (0, 0, 0, 1)
        _Blend("Blend", Range(0, 1)) = 0
    }

    SubShader
    {
        Pass
        {
            Tags
            {
                "RenderType" = "Opaque"
                "Queue" = "Geometry"
            }

            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;
            sampler2D _SecondaryTex;

            fixed4 _MainTex_ST;
            fixed4 _SecondaryTex_ST;
            // fixed4 _Color;
            // fixed4 _SecondaryColor;

            float _Blend;

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
                float2 main_uv = TRANSFORM_TEX(i.uv, _MainTex);
                float2 secondary_uv = TRANSFORM_TEX(i.uv, _SecondaryTex);
                
                fixed4 main_color = tex2D(_MainTex, main_uv);
                fixed4 secondary_color = tex2D(_SecondaryTex, secondary_uv);

                fixed4 col = lerp(main_color, secondary_color, _Blend);
                return col;
            }

            ENDCG
        }
    }
}