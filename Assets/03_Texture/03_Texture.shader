// https://www.ronja-tutorials.com/2018/03/23/textures.html

Shader "Tutorials/03_Texture"
{
    // ShaderLab: Properties
    Properties
    {
        // name([display name], [slider]) = (r, g, b, a)
        _Color("Tint", Color) = (0, 0, 0, 1)

        //  name([display name], [slider]) = "default texture" {}
        _MainText("Texture", 2D) = "white" {}
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

            sampler2D _MainText;
            fixed4 _Color;

            fixed4 _MainText_ST;

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
                o.uv = TRANSFORM_TEX(v.uv, _MainText);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                fixed4 col = tex2D(_MainText, i.uv); 
                col *= _Color;
                return col;
            }

            ENDCG
        }
    }
}