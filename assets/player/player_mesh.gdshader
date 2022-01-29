shader_type spatial;
render_mode specular_schlick_ggx, diffuse_burley, blend_mix;

uniform sampler2D noise;
uniform float fThreshold;
uniform float fHeight;
uniform float fFrequency;
uniform float fRepetition;
uniform vec2 vClipNoiseX;

uniform float columnVoronoi;
uniform float rowVoronoi;

vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
}

vec2 voronoi(vec2 uv, float columns, float rows) {
	
	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
	
	float minimum_dist = 1.0;  
	vec2 minimum_point;

	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor);

			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			
			if(dist < minimum_dist) {
				minimum_dist = dist;
				minimum_point = point;
			}
		}
	}
	return minimum_point;
}

void vertex()
{
	if (voronoi(UV * vec2(TIME / fFrequency), rowVoronoi, columnVoronoi).x > fThreshold && UV.x < vClipNoiseX.y && UV.x > vClipNoiseX.x)
	{
		vec4 fNoise =  fHeight * (texture(noise, fRepetition * UV + vec2(0.0, TIME / fFrequency)) + vec4(1.0));
		VERTEX *= vec3(fNoise.xxx);
		//NORMAL *= (texture(noise, fRepetition * UV * vec2(1.0, TIME / fFrequency)) + vec4(1.0)).xxx;	
	}
}

uniform vec3 albedo;
uniform float transparency;
uniform float metallic;
uniform float specular;
uniform float roughness;
uniform float rim;
uniform float rimTint;
uniform float clearcoat;
uniform float clearcoatGloss;
uniform float sssStrength;
uniform vec3 sssTransmission;
uniform vec3 emissionColor;

void fragment()
{
	ALBEDO = albedo;
	ALPHA = transparency;
	METALLIC = metallic;
	SPECULAR = specular;
	ROUGHNESS = roughness;
	RIM = rim;
	RIM_TINT = rimTint;
	CLEARCOAT = clearcoat;
	CLEARCOAT_GLOSS = clearcoatGloss;
	SSS_STRENGTH = sssStrength;
	TRANSMISSION = sssTransmission;
	EMISSION = emissionColor;
}
