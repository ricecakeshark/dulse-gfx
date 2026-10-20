module dulse_gfx.graphics.desc.sdl_gpu_struct;

public import dulse_sdl.graphics.desc;
import dulse_sdl.graphics.resource.shader;
import sdl.gpu;

struct GfxGraphicsPipelineCreateInfo
{
	GpuVertexShader vertex_shader;
	GpuFragmentShader fragment_shader;
	SDL_GPUVertexInputState vertex_input_state;
	SDL_GPUPrimitiveType primitive_type;
	SDL_GPURasterizerState rasterizer_state;
	SDL_GPUMultisampleState multisample_state;
	SDL_GPUDepthStencilState depth_stencil_state;
	SDL_GPUGraphicsPipelineTargetInfo target_info;

	alias input_state = vertex_input_state;
	alias primitive = primitive_type;
	alias multisample = multisample_state;
	alias depth_stencil = depth_stencil_state;

	GpuGraphicsPipelineCreateInfo opCast(Type : GpuGraphicsPipelineCreateInfo)() const
	{
		return GpuGraphicsPipelineCreateInfo(
			vertex_shader.handle,
			fragment_shader.handle,
			vertex_input_state,
			primitive_type,
			rasterizer_state,
			multisample_state,
			depth_stencil_state,
			target_info,
		);
	}
}

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
