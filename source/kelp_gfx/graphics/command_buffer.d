module kelp_gfx.graphics.command_buffer;

import kelp_sdl.graphics;
import kelp_gfx.graphics;

GpuCommandBuffer acquire(
	GpuCommandBuffer command_buffer,
)
{
	command_buffer.acquire_buffer();
	return command_buffer;
}

GpuCommandBuffer acquire(
	GpuCommandBuffer command_buffer,
	ref GpuSwapchainTexture swapchain_texture,
)
{
	command_buffer.acquire_buffer();
	command_buffer.acquire_texture(swapchain_texture);
	return command_buffer;
}

GpuCommandBuffer copy(
	GpuCommandBuffer command_buffer,
	void delegate(ref GpuCopyPass) dlg,
)
{
	scope GpuCopyPass copy_pass = GpuCopyPass(command_buffer);
	copy_pass.begin();
	dlg(copy_pass);
	copy_pass.end();
	return command_buffer;
}

GpuCommandBuffer render(
	GpuCommandBuffer command_buffer,
	void delegate(ref GpuRenderPass) dlg,
	in GpuColorTargetInfo[] color_target_info_list,
	in GpuDepthStencilTargetInfo depth_stencil_target_info,
)
{
	scope GpuRenderPass render_pass = GpuRenderPass(command_buffer);
	render_pass.begin(
		color_target_info_list,
		depth_stencil_target_info,
	);
	dlg(render_pass);
	render_pass.end();
	return command_buffer;
}

GpuCommandBuffer render(
	GpuCommandBuffer command_buffer,
	void delegate(ref GpuRenderPass) dlg,
	in GpuColorTargetInfo[] color_target_info_list,
)
{
	scope GpuRenderPass render_pass = GpuRenderPass(command_buffer);
	render_pass.begin(
		color_target_info_list,
	);
	dlg(render_pass);
	render_pass.end();
	return command_buffer;
}

// begin() -> process -> end() with Compute pass.
GpuCommandBuffer compute(
	GpuCommandBuffer command_buffer,
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

GpuCommandBuffer compute(
	GpuCommandBuffer command_buffer,
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
