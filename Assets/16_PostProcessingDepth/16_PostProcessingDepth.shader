// https://www.ronja-tutorials.com/2018/07/01/postprocessing-depth.html

Shader "Tutorials/16_PostProcessingDepth"
{
    Properties
    {
        [HideInInspector] _MainTex("Texture", 2D) = "white" {}
        
        [Header(Wave)]
        _WaveDistance("Distance", float) = 10
        _WaveTrail("Trail", Range(0, 10)) = 1
        _WaveColor("Color", Color) = (1, 0, 0, 1)
    }

    SubShader
    {
        Cull off
        ZWrite off
        ZTest Always

        Pass
        {
            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;
            sampler2D _CameraDepthTexture;

            float _WaveDistance;
            float _WaveTrail;
            float4 _WaveColor;

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
                // depth is stored in the red channel of the returned texture
                float depth = tex2D(_CameraDepthTexture, i.uv).r;
                // linear depth between camera and far clipping plane
                depth = Linear01Depth(depth);
                // depth as distance from camera in units
                depth = depth * _ProjectionParams.z;

                // get source color
                fixed4 source = tex2D(_MainTex, i.uv);

                // calculate wave
                float waveFront = step(depth, _WaveDistance);
                float waveTrail = smoothstep(_WaveDistance - _WaveTrail, _WaveDistance, depth); 
                float wave = waveFront * waveTrail;

                // mix wave into source color
                fixed4 col = lerp(source, _WaveColor, wave);

                // skip wave and return source color if we reached far clipping plane
                return depth >= _ProjectionParams.z ? source : col;
            }

            ENDCG
        }
    }
}
