// https://www.ronja-tutorials.com/2018/08/18/stencil-buffers.html

Shader "Tutorials/21_StencilBuffers/Read"
{
   Properties
    {
        [IntRange] _StencilRef("Stencile Reference", Range(0, 255)) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComparison("Stencil Comparison", Int) = 3
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilPassOperation("Stencil Pass Operation", Int) = 0
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"

            /// Put shader earlier in the render queue.
            "Queue" = "Geometry-1"
        }

        stencil
        {
            Ref [_StencilRef]
            Comp [_StencilComparison]
            Pass [_StencilPassOperation]
        }

        Pass
        {
            // Ignore returned color and keep the previously rendered color.
            Blend Zero One

            /// Disable Z buffer to avoid occluding object behind it.
            Zwrite Off

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                return 0;
            }

            ENDCG
        }
    }
}
