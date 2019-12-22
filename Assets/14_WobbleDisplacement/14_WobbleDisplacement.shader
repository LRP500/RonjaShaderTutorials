// https://www.ronja-tutorials.com/2018/06/16/Wobble-Displacement.html

Shader "Tutorials/14_WobbleDisplacement"
{
   Properties
    {
        _Color("Tint", Color) = (0, 0, 0, 1)
        _MainTex("Texture", 2D) = "white" {}
        _Smoothness("Smoothness", Range(0, 1)) = 0
        _Metallic("Metallic", Range(0, 1)) = 0
        [HDR] _Emission("Emission", Color) = (0, 0, 0, 1)

        _Amplitude("Amplitude", Range(0, 1)) = 0.4
        _Frequency("Frequency", Range(1, 10)) = 2
        _AnimationSpeed("Animation Speed", Range(0, 5)) = 1
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }

        CGPROGRAM

        // addshadow allows Unity to recalculate shadows based on modifications made in the vertex shader
        #pragma surface surf Standard fullforwardshadows vertex:vert addshadow
        #pragma target 3.0

        sampler2D _MainTex;
        fixed4 _Color;

        half _Smoothness;
        half _Metallic;
        half3 _Emission;
        float _Amplitude;
        float _Frequency;
        float _AnimationSpeed;

        struct Input
        {
            float2 uv_MainTex;
        };

        // Unity is providing us the appdata_full struct
        // vertex in appdata_full has already been converted to clip space position 
        void vert(inout appdata_full data)
        {
            // calculate modified vertex position
            float4 modifiedPos = data.vertex;
            modifiedPos.y += sin(data.vertex.x * _Frequency + _Time.y * _AnimationSpeed) * _Amplitude;

            // we find close points along tangent and bitangent and use those to correct -
            // - the normal after having modified the vertex position
            float3 posPlusTangent = data.vertex + data.tangent * 0.01;
            posPlusTangent.y += sin(posPlusTangent.x * _Frequency + _Time.y * _AnimationSpeed) * _Amplitude;

            float3 bitangent = cross(data.normal, data.tangent);
            float3 posPlusBiTangent = data.vertex + bitangent * 0.01;
            posPlusBiTangent.y += sin(posPlusBiTangent.x * _Frequency + _Time.y * _AnimationSpeed) * _Amplitude;

            float3 modifiedTangent = posPlusTangent - modifiedPos;
            float3 modifiedBitangent = posPlusBiTangent - modifiedPos;

            float3 modifiedNormal = cross(modifiedTangent, modifiedBitangent);
            data.normal = normalize(modifiedNormal);
            data.vertex = modifiedPos;
        }

        void surf(Input i, inout SurfaceOutputStandard o)
        {
            fixed4 col = tex2D(_MainTex, i.uv_MainTex) * _Color;
            o.Albedo = col.rgb;
            o.Emission = _Emission;
            o.Metallic = _Metallic; 
            o.Smoothness = _Smoothness;
        }

        ENDCG
    }

    FallBack "Standard"
}
