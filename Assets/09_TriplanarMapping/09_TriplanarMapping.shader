// https://www.ronja-tutorials.com/2018/05/11/triplanar-mapping.html

Shader "Tutorials/09_TriplanarMapping"
{
     Properties
    {
        _Color("Tint", Color) = (0, 0, 0, 1)
        _MainTex("Texture", 2D) = "white" {}
        _Sharpness("Blend Sharpness", Range(0, 1)) = 1
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }
        
        Pass
        {
            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;
            fixed4 _MainTex_ST;
            fixed4 _Color;

            float _Sharpness;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float3 worldPos : TEXCOORD0;
                float3 normal : NORMAL;
            };

            v2f vert(appdata v)
            {
                v2f o;
                // calculate position in clip space
                o.position = UnityObjectToClipPos(v.vertex);
                // calculate world position of vertex
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
                // change UVs based on tiling and offset of texture
                o.worldPos = worldPos.xyz;
                // calculate world normal
                float3 worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
                o.normal = normalize(worldNormal);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                // calculate UV coordinates for three projections
                float2 uv_front = TRANSFORM_TEX(i.worldPos.xy, _MainTex);
                float2 uv_side = TRANSFORM_TEX(i.worldPos.zy, _MainTex);
                float2 uv_top = TRANSFORM_TEX(i.worldPos.xz, _MainTex);

                // read texture at uv position of the three projections
                fixed4 col_front = tex2D(_MainTex, uv_front);
                fixed4 col_side = tex2D(_MainTex, uv_side);
                fixed4 col_top = tex2D(_MainTex, uv_top);

                /// generate weights for world normal
                float3 weights = i.normal;
                // show texture on both sides of the object (positive and negative)
                weights = abs(weights);
                // make the transition sharper
                weights = pow(weights, _Sharpness);
                // make it so the sum of all components is 1
                weights = weights / (weights.x + weights.y + weights.z);

                // combine weights with projected colors
                col_front *= weights.z;
                col_side *= weights.x;
                col_top *= weights.y;

                // Combine the projected colors
                fixed4 col = col_front + col_side + col_top; 

                // multiply with tint color
                col *= _Color;
                return col;
            }

            ENDCG
        }
    }

    Fallback "Standard"
}
