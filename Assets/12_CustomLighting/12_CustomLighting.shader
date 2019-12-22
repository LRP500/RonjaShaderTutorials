Shader "Tutorials/12_CustomLighting"
{
    Properties
    {
        _Color("Tint", Color) = (0, 0, 0, 1)
        _MainTex("Texture", 2D) = "white" {}
        _Ramp("Ramp", 2D) = "white" {}
        [HDR] _Emission("Emission", Color) = (0, 0, 0)
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }

        CGPROGRAM

        // the shader is a surface shader, meaning that it will be extended by unity in the background to have fancy lighting and other features
        // our surface shader function is called surf and we use our custom lighting model
        // fullforwardshadows makes sure unity adds the shadow passes the shader might need
        #pragma surface surf Custom fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _Ramp;

        fixed4 _Color;
        half3 _Emission;

        struct Input
        {
            // uvTextureName naming convention allows tiling and offset to be automaticaly set
            float2 uv_MainTex;
        };

        void surf(Input i, inout SurfaceOutput o)
        {
            fixed4 col = tex2D(_MainTex, i.uv_MainTex) * _Color; 
            o.Albedo = col.rgb;
        }

        // the name of this method has to be LightingX where X is the name as reference in the pragma definition.
        float4 LightingCustom(SurfaceOutput s, float3 lightDir, float atten)
        {
            // calculate alignment between light dir and world space normal
            float towardsLight = dot(s.Normal, lightDir);

            // convert to a uv value between 0 and 1
            towardsLight = towardsLight * 0.5 + 0.5;

            // read from toon ramp texture
            float3 intensity = tex2D(_Ramp, towardsLight).rgb;

            float4 col;
            col.rgb = intensity * s.Albedo * atten * _LightColor0.rgb;
            col.a = s.Alpha;

            return col;
        }

        ENDCG
    }

    FallBack "Standard"
}
