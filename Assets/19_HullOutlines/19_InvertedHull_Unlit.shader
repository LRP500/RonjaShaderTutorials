// https://www.ronja-tutorials.com/2018/07/15/postprocessing-outlines.html

Shader "Tutorials/19_InvertedHull/Unlit"
{
    Properties
    {
        _Color("Tint", Color) = (0, 0, 0, 1)
        _MainTex("Texture", 2D) = "white" {}

        _OutlineColor("Outline Color", Color) = (1, 1, 1, 1)
        _OutlineThickness("Outline Thickness", Range(0, 0.1)) = 0.03
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }

        /// Initial texture pass
        Pass
        {
            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;
            fixed4 _MainTex_ST;
            fixed4 _Color;

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
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                fixed4 col = tex2D(_MainTex, i.uv); 
                col *= _Color;
                return col;
            }

            ENDCG
        }

        /// Outline pass
        Pass
        {
            Cull Front

            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            fixed4 _OutlineColor;
            float _OutlineThickness;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;

                // apply outline thickness to vertex position
                float3 normal = normalize(v.normal);
                float3 outlineOffset = normal * _OutlineThickness;
                float3 position = v.vertex + outlineOffset;

                o.position = UnityObjectToClipPos(position);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                return _OutlineColor;
            }

            ENDCG
        }
    }
}
