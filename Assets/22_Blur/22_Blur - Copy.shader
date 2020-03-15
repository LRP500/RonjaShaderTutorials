// https://www.ronja-tutorials.com/2018/08/27/postprocessing-blur.html

Shader "Tutorials/22_Blur"
{
    Properties
    {
        [HideInInspector] _MainTex("Texture", 2D) = "white" {}
        _BlurSize("Blur Size", Range(0, 0.1)) = 0
        [KeywordEnum(BoxLow, BoxMedium, BoxHigh, GaussLow, GaussHigh)] _Samples("Sample Amount", Float) = 0
        [Toggle(GAUSS)] _Gauss("Gaussian Blur", float) = 0
        _StandardDeviation("Standard Deviation (Gauss only)", Range(0, 0.1)) = 0.02
    }

    SubShader
    {
        // No culling or depth
        Cull Off
        ZWrite Off
        ZTest Always

        // Vertical blur
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _SAMPLES_LOW _SAMPLES_MEDIUM _SAMPLES_HIGH
            #pragma shader_feature GAUSS

            #include "UnityCG.cginc"

            #define PI 3.14159265359
            #define E 2.71828182846

            #if _SAMPLES_LOW
                #define SAMPLES 10
            #elif _SAMPLES_MEDIUM
                #define SAMPLES 30
            #else
                #define SAMPLES 100
            #endif
            
            #if GAUSS
                float sum = 0;
            #else
                float sum = SAMPLES;
            #endif

            sampler2D _MainTex;
            float _BlurSize;
            float _StandardDeviation;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
            #if GAUSS
				//failsafe so we can use turn off the blur by setting the deviation to 0
				if(_StandardDeviation == 0)
                {
				    return tex2D(_MainTex, i.uv);
                }
			#endif

			#if GAUSS
				float sum = 0;
			#else
				float sum = SAMPLES;
			#endif

				//init color variable
				float4 col = 0;

				//iterate over blur samples
				for (float index = 0; index < SAMPLES; index++)
                {
					//get the offset of the sample
					float offset = (index / (SAMPLES - 1) - 0.5) * _BlurSize;
					//get uv coordinate of sample
					float2 uv = i.uv + float2(0, offset);
				#if !GAUSS
					//simply add the color if we don't have a gaussian blur (box)
					col += tex2D(_MainTex, uv);
				#else
					//calculate the result of the gaussian function
					float stDevSquared = _StandardDeviation * _StandardDeviation;
					float gauss = (1 / sqrt(2 * PI * stDevSquared)) * pow(E, -((offset * offset) / (2 * stDevSquared)));
					//add result to sum
					sum += gauss;
					//multiply color with influence from gaussian function and add it to sum color
					col += tex2D(_MainTex, uv) * gauss;
				#endif
				}

				//divide the sum of values by the amount of samples
				col = col / sum;
				return col;
            }

            ENDCG
        }

        // Horizontal blur
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #pragma multi_compile _SAMPLES_LOW _SAMPLES_MEDIUM _SAMPLES_HIGH
            #pragma shader_feature GAUSS

            #include "UnityCG.cginc"

            #define PI 3.14159265359
            #define E 2.71828182846

            #if _SAMPLES_LOW
                #define SAMPLES 10
            #elif _SAMPLES_MEDIUM
                #define SAMPLES 30
            #else
                #define SAMPLES 100
            #endif

            #if GAUSS
                float sum = 0;
            #else
                float sum = SAMPLES;
            #endif


            sampler2D _MainTex;
            float _BlurSize;
            float _StandardDeviation;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
            #if GAUSS
				//failsafe so we can use turn off the blur by setting the deviation to 0
				if(_StandardDeviation == 0)
                {
				    return tex2D(_MainTex, i.uv);
                }
			#endif

			#if GAUSS
				float sum = 0;
			#else
				float sum = SAMPLES;
			#endif
				
                //calculate aspect ratio
				float invAspect = _ScreenParams.y / _ScreenParams.x;
				
                //init color variable
				float4 col = 0;

				//iterate over blur samples
				for (float index = 0; index < SAMPLES; index++)
                {
					//get the offset of the sample
					float offset = (index / (SAMPLES - 1) - 0.5) * _BlurSize * invAspect;
					//get uv coordinate of sample
					float2 uv = i.uv + float2(offset, 0);
				#if !GAUSS
					//simply add the color if we don't have a gaussian blur (box)
					col += tex2D(_MainTex, uv);
				#else
					//calculate the result of the gaussian function
					float stDevSquared = _StandardDeviation * _StandardDeviation;
					float gauss = (1 / sqrt(2 * PI * stDevSquared)) * pow(E, -((offset * offset) / (2 * stDevSquared)));
					//add result to sum
					sum += gauss;
					//multiply color with influence from gaussian function and add it to sum color
					col += tex2D(_MainTex, uv) * gauss;
				#endif
				}
                
				//divide the sum of values by the amount of samples
				col = col / sum;
				return col;
            }

            ENDCG
        }
    }
}
