module kelp_render.compute_context;

import kelp_sdl;

class GPUComputeContext
{
	GPUCommandBuffer command_buffer;
	GPUComputePass compute_pass;

	this(GPUDevice device)
	{
		this.command_buffer = new GPUCommandBuffer(device);
		this.compute_pass = new GPUComputePass();
		return;
	}

	typeof(this) acquire()
	{
		this.command_buffer.acquire();
		return this;
	}

	typeof(this) begin(
		GPUStorageTextureReadWriteBinding[] texture_binding_list,
	)
	{
		this.compute_pass.begin(
			this.command_buffer,
			texture_binding_list,
		);
		return this;
	}

	typeof(this) begin(
		GPUStorageTextureReadWriteBinding[] texture_binding_list,
		GPUStorageBufferReadWriteBinding[] buffer_binding_list,
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

	typeof(this) bind(GPUComputePipeline pipeline)
	{
		this.compute_pass.bind(pipeline);
		return this;
	}

	typeof(this) dispatch(uint count_x, uint count_y, uint count_z)
	{
		this.compute_pass.dispatch(count_x, count_y, count_z);
		return this;
	}

	typeof(this) submit()
	{
		this.command_buffer.submit();
		return this;
	}
}
