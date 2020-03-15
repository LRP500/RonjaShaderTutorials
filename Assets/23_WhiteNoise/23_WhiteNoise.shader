
// https://www.ronja-tutorials.com/2018/09/02/white-noise.html

Shader "Tutorials/23_WhiteNoise/Random"
{
    Properties
    {
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

        #include "WhiteNoise.cginc"

        struct Input
        {
            float worldPos;
        };

        void surf(Input i, inout SurfaceOutputStandard o)
        {
            o.Albedo = rand3dTo3d(i.worldPos);
        }

        ENDCG
    }

    FallBack "Standard"
}
