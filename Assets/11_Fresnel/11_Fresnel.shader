Shader "Tutorials/11_Fresnel"
{
    Properties
    {
        _Color("Color", Color) = (0 , 0, 0, 1)
        _FresnelColor("Fresnel Color", Color) = (0, 0, 0, 1)
        [PowerSlider(4)] _FresnelExponent("Fresnel Exponent", Range(0, 4)) = 1
        [HDR] _Emission("Emission", Color) = (0 , 0, 0, 1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0, 1)) = 0.5
        _Metallic("Metallic", Range(0, 1)) = 0.0
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

        half _Glossiness;
        half _Metallic;
        
        fixed4 _Color;
        fixed4 _Emission;
        fixed4 _FresnelColor;

        float _FresnelExponent;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir;
            INTERNAL_DATA
        };

        void surf(Input i, inout SurfaceOutputStandard o)
        {
            fixed4 col = tex2D(_MainTex, i.uv_MainTex) * _Color;
            o.Albedo = col.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Emission = _Emission;
            o.Alpha = col.a;

            // dot product between world normal and direction
            float fresnel = dot(i.worldNormal, i.viewDir);

            // clamp the value between 0 and 1 so we don't get dark artefacts at the backside
            // saturate is faster than clamp on some GPUs
            fresnel = saturate(1 - fresnel);

            // apply fresnel color
            fixed4 fresnelColor = fresnel * _FresnelColor;

            // apply exponent
            fresnel = pow(fresnel, _FresnelExponent);

            // apply the fresnel value to the emission
            o.Emission = (_Emission + fresnelColor) * _FresnelExponent;
        }

        ENDCG
    }

    FallBack "Diffuse"
}
