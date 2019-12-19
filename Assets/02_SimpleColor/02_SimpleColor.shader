// https://www.ronja-tutorials.com/2018/03/21/simple-color.html

Shader "Tutorials/02_SimpleColor"
{
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

			// 3D object input data
			struct appdata 
			{
				float4 vertex : POSITION;
			};

			// Return by the vertex shader and to the rasterizer
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
				return fixed4(0.5, 0, 0, 1);
			}

			ENDCG
		}
	}
}