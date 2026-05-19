module kelp_gfx.graphics.frame_context;

import kelp_sdl.graphics.command.command_buffer;
import kelp_sdl.graphics.resource.texture.swapchain_texture;

/+struct GpuFrameContext
{
	GpuCommandBuffer command_buffer;
	GpuSwapchainTexture swapchain_texture;

	typeof(this) create(GpuDevice device, GpuWindow window)
	{
		this.command_buffer = new GpuCommandBuffer(device);
		this.swapchain_texture = new GpuSwapchainTexture(device, window);
		return this;
	}

	typeof(this) acquire_buffer()
	{
		this.command_buffer.acquire_buffer();
		return this;
	}

	typeof(this) acquire_texture()
	{
		this.command_buffer.acquire(this.swapchain_texture);
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
}
+/