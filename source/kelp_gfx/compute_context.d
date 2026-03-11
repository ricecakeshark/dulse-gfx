module kelp_gfx.compute_context;

import kelp_sdl;

class GfxComputeContext
{
	GpuCommandBuffer command_buffer;
	GpuComputePass compute_pass;
	GpuSwapchainTexture swapchain_texture;

	this(GpuDevice device, GpuWindow window)
	{
		this.command_buffer = new GpuCommandBuffer(device, window);
		this.compute_pass = new GpuComputePass();
		this.swapchain_texture = new GpuSwapchainTexture(device, window);
		return;
	}

	typeof(this) release()
	{
		this.command_buffer = null;
		this.compute_pass = null;
		this.swapchain_texture = null;
		return this;
	}

	typeof(this) acquire_buffer()
	{
		this.command_buffer.acquire_buffer();
		return this;
	}

	typeof(this) acquire_texture()
	{
		this.command_buffer.acquire_texture(swapchain_texture);
		return this;
	}

	typeof(this) if_acquired(void delegate() dlg)
	{
		if (this.swapchain_texture.handle !is null)
		{
			dlg();
		}
		return this;
	}

	typeof(this) begin(
		GpuStorageTextureReadWriteBinding[] texture_binding_list,
	)
	{
		this.compute_pass.begin(
			this.command_buffer,
			texture_binding_list,
		);
		return this;
	}

	typeof(this) begin(
		GpuStorageTextureReadWriteBinding[] texture_binding_list,
		GpuStorageBufferReadWriteBinding[] buffer_binding_list,
	)
	{
		this.compute_pass.begin(
			this.command_buffer,
			texture_binding_list,
			buffer_binding_list,
		);
		return this;
	}

	typeof(this) end()
	{
		this.compute_pass.end();
		return this;
	}

	typeof(this) bind(GpuComputePipeline pipeline)
	{
		this.compute_pass.bind(pipeline);
		return this;
	}

	typeof(this) bind(GpuTextureSamplerBinding[] binding_list, uint first_slot = 0)
	{
		this.compute_pass.bind(binding_list, first_slot);
		return this;
	}

	typeof(this) push_uniform(Type)(Type data)
	{
		this.command_buffer.push_uniform(data);
		return this;
	}

	typeof(this) dispatch(in uint count_x, in uint count_y, in uint count_z)
	{
		this.compute_pass.dispatch(count_x, count_y, count_z);
		return this;
	}

	typeof(this) submit()
	{
		this.command_buffer.submit();
		return this;
	}

	typeof(this) blit_texture(in GpuBlitInfo blit_info)
	{
		this.command_buffer.blit_texture(blit_info);
		return this;
	}
}
