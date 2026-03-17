module kelp_gfx.upload_context;

import kelp_sdl.graphics.command;
import kelp_sdl.graphics.core.gpu_device;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource.buffer;

class GfxUploadContext
{
	GpuCommandBuffer command_buffer;
	GpuCopyPass copy_pass;

	this(GpuDevice device)
	{
		this.command_buffer = new GpuCommandBuffer(device);
		this.copy_pass = GpuCopyPass(this.command_buffer);
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
		return this;
	}

	typeof(this) begin()
	{
		this.command_buffer.acquire_buffer();
		this.copy_pass.begin();
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
		in GpuTransferBufferLocation transfer_buffer_location,
		in GpuBufferRegion buffer_region,
	)
	{
		this.copy_pass.upload(
			transfer_buffer_location,
			buffer_region,
		);
		return this;
	}

	typeof(this) upload(
		in GpuTextureTransferInfo transfer_buffer_location,
		in GpuTextureRegion texture_region,
	)
	{
		this.copy_pass.upload(
			transfer_buffer_location,
			texture_region,
		);
		return this;
	}
}
