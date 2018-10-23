Shader "Test/Barrel"
{
	Properties
	{
		_V("V",Vector) = (1,1,1,0)
		_MainTex("Texture", 2D) = "white" {}
	}

		SubShader
	{
		Tags{ "RenderType" = "Opaque" "Queue" = "Geometry"}

		Pass
		{
			Cull BacK
			Stencil
			{
				Ref 1
				Comp Always
				Pass Replace
			}

		Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase

			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"

		struct a2v
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
		};

		struct v2f
		{
			float4 pos  : SV_POSITION;
			float2 uv : TEXCOORD0;
			float3 modelPos:TEXCOORD1;
		};

		sampler2D _MainTex;
		float4 _MainTex_ST;
		float4 _V;

		v2f vert(a2v v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.modelPos = v.vertex.xyz;
			o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			fixed4 texColor = tex2D(_MainTex, i.uv);

			if (i.modelPos.y > _V.y || i.modelPos.x > _V.x || i.modelPos.z > _V.z)
			{
				discard;
			}

		return texColor;
		}
		ENDCG
		}

		Pass
		{
			Cull Front
			Stencil
			{
				Ref 2
				Comp Always
				Pass Replace
			}

		Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"

		struct v2f
		{
			float4 vertex : SV_POSITION;
			float2 uv : TEXCOORD0;
			float3 modelPos:TEXCOORD1;
			float3 worldNormal:TEXCOORD2;
		};

		sampler2D _MainTex;
		float4 _MainTex_ST;
		float4 _V;

		v2f vert(appdata_base v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.modelPos = v.vertex.xyz;
			o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
			o.worldNormal = v.normal;
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{

			if (i.modelPos.y > _V.y || i.modelPos.x > _V.x || i.modelPos.z > _V.z)
			{
				discard;
			}

		return tex2D(_MainTex, i.uv);
		}
		ENDCG
		}

			//处理影子
			Pass
			{
				Tags{ "LightMode" = "ShadowCaster" }

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_shadowcaster
				#pragma multi_compile_instancing
				#include "UnityCG.cginc"

			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2  uv : TEXCOORD1;
				float3 modelPos:TEXCOORD2;
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _MainTex_ST;

			v2f vert(appdata_base v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);	
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				o.modelPos = v.vertex.xyz;
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			sampler2D _MainTex;
			float4 _V;

			float4 frag(v2f i) : SV_Target
			{
				fixed4 texcol = tex2D(_MainTex, i.uv);

			if (i.modelPos.y > _V.y || i.modelPos.x > _V.x || i.modelPos.z > _V.z)
			{
				discard;
			}

			SHADOW_CASTER_FRAGMENT(i)
			}
				ENDCG
			}
	}
		Fallback Off
}