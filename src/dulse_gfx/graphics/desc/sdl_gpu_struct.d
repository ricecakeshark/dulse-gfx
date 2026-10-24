module dulse_gfx.graphics.desc.sdl_gpu_struct;

public import dulse_sdl.graphics.desc;
import dulse_sdl.graphics.resource.shader;
import sdl.gpu;
import dulse_gfx.graphics.resource;

/+GpuTextureSamplerBinding binding(GfxTexture texture, Sampler sampler)
{
	return GpuTextureSamplerBinding(texture.handle, sampler.handle);
}+/

struct GfxComputePipelineCreateInfo
{
	ShaderFile shader_file;
	uint num_samplers;
	uint num_readonly_storage_textures;
	uint num_readonly_storage_buffers;
	uint num_readwrite_storage_textures;
	uint num_readwrite_storage_buffers;
	uint num_uniform_buffers;
	uint threadcount_x;
	uint threadcount_y;
	uint threadcount_z;

	GpuComputePipelineCreateInfo opCast(Type : GpuComputePipelineCreateInfo)() const pure nothrow @nogc
	{
		return GpuComputePipelineCreateInfo(
			shader_file.code.length,
			cast(const(ubyte)*) shader_file.code,
			shader_file.entry_point.ptr,
			cast(GpuShaderFormat) shader_file.frontend_format,
			num_samplers,
			num_readonly_storage_textures,
			num_readonly_storage_buffers,
			num_readwrite_storage_textures,
			num_readwrite_storage_buffers,
			num_uniform_buffers,
			threadcount_x, threadcount_y, threadcount_z,
		);
	}
}

struct GfxGraphicsPipelineCreateInfo
{
	GpuVertexShader vertex_shader;
	GpuFragmentShader fragment_shader;
	GpuVertexInputState vertex_input_state;
	GpuPrimitiveType primitive_type;
	GpuRasterizerState rasterizer_state;
	GpuMultisampleState multisample_state;
	GpuDepthStencilState depth_stencil_state;
	GfxGraphicsPipelineTargetInfo target_info;

	alias input_state = vertex_input_state;
	alias primitive = primitive_type;
	alias multisample = multisample_state;
	alias depth_stencil = depth_stencil_state;

	GpuGraphicsPipelineCreateInfo opCast(Type : GpuGraphicsPipelineCreateInfo)() const
	{
		return GpuGraphicsPipelineCreateInfo(
			cast(SDL_GPUShader*)vertex_shader.handle,
			cast(SDL_GPUShader*)fragment_shader.handle,
			cast()vertex_input_state,
			primitive_type,
			rasterizer_state,
			multisample_state,
			depth_stencil_state,
			cast(GpuGraphicsPipelineTargetInfo)target_info,
		);
	}
}

struct GfxGraphicsPipelineTargetInfo
{
	GpuColorTargetDescription[] color_target_descriptions;
	GpuTextureFormat depth_stencil_format = GpuTextureFormat.invalid;

	GpuGraphicsPipelineTargetInfo opCast(Type : GpuGraphicsPipelineTargetInfo)() inout
	{
		return GpuGraphicsPipelineTargetInfo(
			color_target_descriptions,
			depth_stencil_format,
		);
	}
}

// generate alias 
import std.algorithm : startsWith;
import std.string : chompPrefix;
import std.conv : text;

private alias Module = mixin(__MODULE__);
static foreach (member; __traits(allMembers, Module))
{

	static if (
		(is(__traits(getMember, Module, member) == struct)
			|| is(__traits(getMember, Module, member) == union))
		&& member.startsWith("Gfx")
		)
	{
		// ex: alias CreateInfo = GfxCreateInfo;
		mixin("alias ", member.chompPrefix("Gfx"), " = ", member, ";");
		//pragma(msg, text("alias ", member.chompPrefix("Gfx"), " = ", member, ";"));
	}
}
