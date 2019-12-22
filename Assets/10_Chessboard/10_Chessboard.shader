// https://www.ronja-tutorials.com/2018/05/18/Chessboard.html

Shader "Tutorials/10_Chessboard"
{
    Properties
    {
        _Scale("Pattern Size", Range(0, 10)) = 1
        _EvenColor("Even Color", Color) = (0, 0, 0, 1)
        _OddColor("Odd Color", Color) = (0, 0, 0, 1)
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

            fixed4 _EvenColor;
            fixed4 _OddColor;
            float _Scale;

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {   
                float4 position : SV_POSITION;
                float3 worldPos : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                float3 adjustedWorldPos = floor(i.worldPos / _Scale);

                float chessboard = adjustedWorldPos.x + adjustedWorldPos.y + adjustedWorldPos.z;

                // divide it by 2 and get the fractional part, resulting in a value of 0 for even and 0.5 for odd numbers
                chessboard = frac(chessboard * 0.5);

                chessboard *= 2;

                fixed4 color = lerp(_EvenColor, _OddColor, chessboard);
                return color;
            }

            ENDCG
        }
    }
    
    FallBack "Standard"
}
