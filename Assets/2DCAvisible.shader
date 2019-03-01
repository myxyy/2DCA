Shader "2DCA/visible"
{
	Properties
	{
		_MainTex ("Data texture", 2D) = "white" {}
		_Init ("Initial state", 2D) = "black"{}
		_Width("Width", Int) = 32
		_Height ("Height", Int) = 32
		[Space]
		_Interval ("Interval", Float) = 1.0
		_RSteps ("Repeat Steps (Set 0 to forbid repeat)", Int) = 0
		[Space]
		[MaterialToggle] _IsRand("Randomize", Float) = 0
		_Density("Density", Range(0.,1.)) = 0
		[Header(Birth)]
		[MaterialToggle] _B0("0", Float) = 0
		[MaterialToggle] _B1("1", Float) = 0
		[MaterialToggle] _B2("2", Float) = 0
		[MaterialToggle] _B3("3", Float) = 1
		[MaterialToggle] _B4("4", Float) = 0
		[MaterialToggle] _B5("5", Float) = 0
		[MaterialToggle] _B6("6", Float) = 0
		[MaterialToggle] _B7("7", Float) = 0
		[MaterialToggle] _B8("8", Float) = 0
		[Header(Survive)]
		[MaterialToggle] _S0("0", Float) = 0
		[MaterialToggle] _S1("1", Float) = 0
		[MaterialToggle] _S2("2", Float) = 1
		[MaterialToggle] _S3("3", Float) = 1
		[MaterialToggle] _S4("4", Float) = 0
		[MaterialToggle] _S5("5", Float) = 0
		[MaterialToggle] _S6("6", Float) = 0
		[MaterialToggle] _S7("7", Float) = 0
		[MaterialToggle] _S8("8", Float) = 0
	}
	SubShader
	{
		Tags {
			"Queue"="Overlay"
			"RenderType"="Opaque" 
		}
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			sampler2D _Init;
			int _Height;
			int _Width;

			float _Interval;
			int _RSteps;

			float _IsRand;
			float _Density;

			float _B0;
			float _B1;
			float _B2;
			float _B3;
			float _B4;
			float _B5;
			float _B6;
			float _B7;
			float _B8;

			float _S0;
			float _S1;
			float _S2;
			float _S3;
			float _S4;
			float _S5;
			float _S6;
			float _S7;
			float _S8;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{				

				float delegatex = (floor(i.uv.x*_Width) + .5) / _Width;
				float delegatey = (floor(i.uv.y*_Height) + .5) / _Height;
				fixed4 white = fixed4(1, 1, 1, 1);
				fixed4 black = fixed4(0, 0, 0, 1);
				float cellw = 1. / _Width;
				float cellh = 1. / _Height;
				float2 cell[8]; //ul,um,ur,l,r,ll,lm,lr
				float2 cellc  = float2(delegatex, delegatey);
				cell[0] = float2(fmod(delegatex + 1. - cellw, 1.), fmod(delegatey + 1. + cellh, 1.));
				cell[1] = float2(fmod(delegatex + 1.        , 1.), fmod(delegatey + 1. + cellh, 1.));
				cell[2] = float2(fmod(delegatex + 1. + cellw, 1.), fmod(delegatey + 1. + cellh, 1.));
				cell[3] = float2(fmod(delegatex + 1. - cellw, 1.), fmod(delegatey + 1.        , 1.));
				cell[4] = float2(fmod(delegatex + 1. + cellw, 1.), fmod(delegatey + 1.        , 1.));
				cell[5] = float2(fmod(delegatex + 1. - cellw, 1.), fmod(delegatey + 1. - cellh, 1.));
				cell[6] = float2(fmod(delegatex + 1.        , 1.), fmod(delegatey + 1. - cellh, 1.));
				cell[7] = float2(fmod(delegatex + 1. + cellw, 1.), fmod(delegatey + 1. - cellh, 1.));


				fixed4 col = float4(dot(tex2D(_MainTex, cellc).rgb, (float3)1) > 1.5 ? (float3)1 : (float3)0, 1);
		
				int livN = 0;
				[unroll]
				for (int j = 0; j < 8; j++)livN += (tex2D(_MainTex, cell[j]).r > .5 ? 1 : 0);
				float switchingTime = floor(_Time.y / _Interval)*_Interval;
				if ((_Time.y < _Interval) || (_Time.y - unity_DeltaTime.x < switchingTime && switchingTime <= _Time.y)) {
					if(
						(_Time.y <= _Interval) ||
						(
							_RSteps != 0. &&
							floor(_Time.y/_Interval)-1.0 < floor(_Time.y/(_Interval*(float)_RSteps))*(float)_RSteps
						)
					)
					{
						if (_IsRand == 0.) {
							col = dot(tex2D(_Init, cellc).rgb, (float3)1) < 1.5 ? black : white;
						}else {
							col = frac(sin(dot(cellc + float2((_Time.y <= _Interval ? 0 : _Time.y), 0), fixed2(12.9898, 78.233))) * 43758.5453) > _Density ? black : white;
						}
					}
					else if (dot(tex2D(_MainTex, cellc).rgb,(float3)1) < 1.5) {
						col = black;
						col = livN == 0 && _B0 ? white : col;
						col = livN == 1 && _B1 ? white : col;
						col = livN == 2 && _B2 ? white : col;
						col = livN == 3 && _B3 ? white : col;
						col = livN == 4 && _B4 ? white : col;
						col = livN == 5 && _B5 ? white : col;
						col = livN == 6 && _B6 ? white : col;
						col = livN == 7 && _B7 ? white : col;
						col = livN == 8 && _B8 ? white : col;
					}
					else {
						col = white;
						col = livN == 0 && !_S0 ? black : col;
						col = livN == 1 && !_S1 ? black : col;
						col = livN == 2 && !_S2 ? black : col;
						col = livN == 3 && !_S3 ? black : col;
						col = livN == 4 && !_S4 ? black : col;
						col = livN == 5 && !_S5 ? black : col;
						col = livN == 6 && !_S6 ? black : col;
						col = livN == 7 && !_S7 ? black : col;
						col = livN == 8 && !_S8 ? black : col;
					}
				}

				return col;
			}
			ENDCG
		}
	}
}
