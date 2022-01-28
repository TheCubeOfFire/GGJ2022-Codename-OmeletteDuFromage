shader_type spatial;
render_mode specular_schlick_ggx, diffuse_burley, blend_mix, depth_draw_alpha_prepass;

uniform sampler2D noise;
uniform float fHeight;
uniform float fFrequency;
uniform float fRepetition;

void vertex()
{
	vec4 fNoise = fHeight * texture(noise, fRepetition * UV * vec2(1.0, sin(TIME / fFrequency)));
	VERTEX *= vec3(fNoise.xxx);
	NORMAL *= texture(noise, fRepetition * UV * vec2(1.0, sin(TIME / fFrequency))).xxx;
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
