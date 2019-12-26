// https://www.ronja-tutorials.com/2018/03/30/simple-surface.html

Shader "Tutorials/04_Surface"
{
    Properties
    {
        _Color("Tint", Color) = (1, 1, 1, 1)
        _MainTex("Texture", 2D) = "white" {}
        _Smoothness("Smoothness", Range(0, 1)) = 0
        _Metallic("Metallic", Range(0, 1)) = 0
        [HDR] _Emission("Emission", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        fixed4 _Color;

        half _Smoothness;
        half _Metallic;
        half3 _Emission;

        struct Input
        {
            // uvTextureName naming convention allows tiling and offset to be automaticaly set
            float2 uv_MainTex;
        };

        void surf(Input i, inout SurfaceOutputStandard o)
        {
            fixed4 col = tex2D(_MainTex, i.uv_MainTex); 
            col *= _Color;
            o.Albedo = col.rgb;
            o.Metallic = _Metallic; 
            o.Smoothness = _Smoothness;
            o.Emission = _Emission;
        }

        ENDCG
    }

    FallBack "Standard"
}
