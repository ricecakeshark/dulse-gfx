module dulse_gfx.graphics.command.command_buffer;

import dulse_sdl.graphics;
import dulse_sdl.graphics.desc;
import dulse_gfx.graphics.command;
import dulse_gfx.graphics.resource;
import dulse_gfx.graphics.desc.dulse_gfx_struct;

import dulse.core.meta;

alias CommandBuffer = GpuCommandBuffer;

CommandBuffer acquire(
	CommandBuffer command_buffer,
)
{
	command_buffer.acquire_buffer();
	return command_buffer;
}

CommandBuffer acquire(
	CommandBuffer command_buffer,
	ref GpuSwapchainTexture swapchain_texture,
)
{
	command_buffer.acquire_buffer();
	command_buffer.acquire_texture(swapchain_texture);
	return command_buffer;
}

CommandBuffer copy(
	CommandBuffer command_buffer,
	void delegate(ref GpuCopyPass) dlg,
)
{
	scope GpuCopyPass copy_pass = GpuCopyPass(command_buffer);
	copy_pass.begin();
	dlg(copy_pass);
	copy_pass.end();
	return command_buffer;
}

CommandBuffer copy(TypeSeq...)(
	CommandBuffer command_buffer,
	TypeSeq sequence_list,
) //if (TypeSeq.allStatisfy)
{
	scope GpuCopyPass copy_pass = GpuCopyPass(command_buffer);
	copy_pass.begin();
	foreach (sequence; filter_by_type!(
			GfxCopyBufferSequence, sequence_list))
	{
		copy_pass.upload(
			sequence.bt_buffer,
			sequence.buffer_list,
		);
	}
	foreach (sequence; filter_by_type!(
			GfxCopyTextureSequence, sequence_list))
	{
		copy_pass.upload(
			sequence.tt_buffer,
			sequence.texture_list,
		);
	}
	copy_pass.end();
	return command_buffer;
}

CommandBuffer render(TypeSeq...)(
	CommandBuffer command_buffer,
	void delegate(ref RenderPass) dlg,
	TypeSeq info_list,
)
in (ColorTargetInfo.contain_all!TypeSeq)
{
	scope RenderPass render_pass = RenderPass(command_buffer);
	render_pass.begin(
		[filter_by_type!(GpuColorTargetInfo, info_list)],
		filter_by_type!(GpuDepthStencilTargetInfo, info_list)[0],
	);
	dlg(render_pass);
	render_pass.end();
	return command_buffer;
}

CommandBuffer render(
	CommandBuffer command_buffer,
	void delegate(ref RenderPass) dlg,
	in GpuColorTargetInfo[] color_target_info_list,
	in GpuDepthStencilTargetInfo depth_stencil_target_info,
)
{
	scope RenderPass render_pass = RenderPass(command_buffer);
	render_pass.begin(
		color_target_info_list,
		depth_stencil_target_info,
	);
	dlg(render_pass);
	render_pass.end();
	return command_buffer;
}

CommandBuffer render(
	CommandBuffer command_buffer,
	void delegate(ref RenderPass) dlg,
	in GpuColorTargetInfo[] color_target_info_list,
)
{
	scope RenderPass render_pass = RenderPass(command_buffer);
	render_pass.begin(
		color_target_info_list,
	);
	dlg(render_pass);
	render_pass.end();
	return command_buffer;
}

// begin() -> process -> end() with Compute pass.
CommandBuffer compute(TypeSeq...)(
	CommandBuffer command_buffer,
	void delegate(ref ComputePass) dlg,
	TypeSeq bindable_list,
)
in (ComputeBinding.contain_all!TypeSeq)
{
	import std : map, array;

	scope GpuComputePass compute_pass = GpuComputePass(command_buffer);

	compute_pass.begin(
		[
			filter_by_type!(GpuStorageTextureReadWriteBinding, bindable_list),
		]
			~ (cast(GfxTexture[])[filter_by_type!(GfxTexture, bindable_list)])
			.map!(tex => GpuStorageTextureReadWriteBinding(tex))
			.array,
			[
				filter_by_type!(GpuStorageBufferReadWriteBinding, bindable_list),
			]
			~ (cast(GpuStorageBuffer[])[filter_by_type!(GpuStorageBuffer, bindable_list)])
			.map!(sb => GpuStorageBufferReadWriteBinding(sb))
			.array
	);
	dlg(compute_pass);
	compute_pass.end();
	return command_buffer;
}

CommandBuffer compute(
	CommandBuffer command_buffer,
	void delegate(ref GpuComputePass) dlg,
	in GpuStorageTextureReadWriteBinding[] texture_binding_list,
	in GpuStorageBufferReadWriteBinding[] buffer_binding_list,
)
{
	scope GpuComputePass compute_pass = GpuComputePass(command_buffer);
	compute_pass.begin(
		texture_binding_list,
		buffer_binding_list,
	);
	dlg(compute_pass);
	compute_pass.end();
	return command_buffer;
}

CommandBuffer compute(
	CommandBuffer command_buffer,
	void delegate(
		ref GpuComputePass) dlg,
	in GpuStorageTextureReadWriteBinding[] texture_binding_list,
)
{
	scope GpuComputePass compute_pass = GpuComputePass(command_buffer);
	compute_pass.begin(
		texture_binding_list,
	);
	dlg(compute_pass);
	compute_pass.end();
	return command_buffer;
}

CommandBuffer blit(
	CommandBuffer cb,
	Texture texture_src,
	Texture texture_dest,
)
{
	cb.blit(
		GpuBlitInfo(
			GpuBlitRegion(texture_src),
			GpuBlitRegion(texture_dest),
	),
	);
	return cb;
}

alias ColorTargetInfo = AliasList!(
	GpuColorTargetInfo, GpuDepthStencilTargetInfo,
);

alias ComputeBinding = AliasList!(
	GpuStorageTextureReadWriteBinding,
	GpuStorageBufferReadWriteBinding,
	GfxTexture, GpuStorageBuffer,
);

template to_strw_binding(alias symbol)
{
	static assert(is(typeof(symbol) == GfxTexture));
	alias to_strw_binding = GpuStorageTextureReadWriteBinding(symbol);
}

template to_sbrw_binding(alias symbol)
{
	static assert(is(typeof(symbol) == GpuStorageBuffer));
	alias to_sbrw_binding = GpuStorageBufferReadWriteBinding(symbol);
}
