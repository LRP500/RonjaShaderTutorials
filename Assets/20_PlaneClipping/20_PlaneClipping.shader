// https://www.ronja-tutorials.com/2018/08/06/plane-clipping.html

Shader "Tutorials/20_PlaneClipping"
{
    Properties
    {
        _Color("Tint", Color) = (1, 1, 1, 1)
        _MainTex("Texture", 2D) = "white" {}
        _Smoothness("Smoothness", Range(0, 1)) = 0
        _Metallic("Metallic", Range(0, 1)) = 0
        [HDR] _Emission("Emission", Color) = (1, 1, 1, 1)
        [HDR] _CutoffColor("Cutoff Color", Color) = (1, 0, 0, 0)
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }

        Cull off

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows addshadow
        #pragma target 3.0

        sampler2D _MainTex;

        fixed4 _Color;
        fixed4 _CutoffColor;

        half _Smoothness;
        half _Metallic;
        half3 _Emission;

        float4 _Plane;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;

            // 1 if it belongs to the outside surface, -1 otherwise
            float facing : VFACE;
        };

        void surf(Input i, inout SurfaceOutputStandard o)
        {
            // get distance between world space vertex and origin
            float distance = dot(i.worldPos, _Plane.xyz);
            // add the distance from origin to plane
            distance = distance + _Plane.w;
            // clip everything above plane
            // we inverse distance so that value in front of plane are discarded
            clip(-distance);

            // convert facing into a value between 0 and 1
            float facing = i.facing * 0.5 + 0.5;

            // apply surface color data
            fixed4 col = tex2D(_MainTex, i.uv_MainTex); 
            col *= _Color;
            o.Albedo = col.rgb * facing;
            o.Metallic = _Metallic * facing;
            o.Smoothness = _Smoothness * facing;
            o.Emission = lerp(_CutoffColor, _Emission, facing);
        }

        ENDCG
    }

    FallBack "Standard" // fallback adds a shadow pass so we get shadows on other objects
}