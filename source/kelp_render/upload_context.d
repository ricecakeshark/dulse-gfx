module kelp_render.upload_context;

import kelp_sdl.graphics.command;
import kelp_sdl.graphics.core.gpu_device;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource.buffer;

class GPUUploadContext
{
	GPUCommandBuffer command_buffer;
	GPUCopyPass copy_pass;

	this(GPUDevice device)
	{
		this.command_buffer = new GPUCommandBuffer(device);
		this.copy_pass = new GPUCopyPass();

		return;
	}

	~this()
	{
		this.release();
		return;
	}

	typeof(this) release()
	{
		this.command_buffer = null;
		this.copy_pass = null;
		return this;
	}

	typeof(this) begin()
	{
		this.command_buffer.acquire();
		this.copy_pass.begin(this.command_buffer);
		return this;
	}

	typeof(this) end()
	{
		this.copy_pass.end();
		return this;
	}

	typeof(this) submit()
	{
		this.command_buffer.submit();
		return this;
	}

	typeof(this) upload(
		GPUTransferBufferLocation transfer_buffer_location,
		GPUBufferRegion buffer_region,
	)
	{
		this.copy_pass.upload(
			transfer_buffer_location,
			buffer_region,
		);
		return this;
	}

	typeof(this) upload(
		GPUTextureTransferInfo transfer_buffer_location,
		GPUTextureRegion texture_region,
	)
	{
		this.copy_pass.upload(
			transfer_buffer_location,
			texture_region,
		);
		return this;
	}
}
