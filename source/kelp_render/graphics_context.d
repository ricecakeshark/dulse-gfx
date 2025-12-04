module kelp_render.graphics_context;

import bindbc.sdl;
import kelp_sdl;
import kelp_render;

class GPUGraphicsContext
{
	public GPUDevice device;
	public GPUWindow window;

	this()
	{

		return;
	}

	~this()
	{
		this.release();
		return;
	}

	typeof(this) initialize()
	{
		this.device = new GPUDevice();
		this.device.create();
		this.window = new GPUWindow();
		this.window.create(960, 540, "");
		this.device.claim(this.window);
		return this;
	}

	typeof(this) release()
	{
		if (this.window !is null && this.device !is null)
		{
			this.device.release_window(this.window);
		}
		if (this.window !is null)
		{
			this.window.release();
			this.window = null;
		}
		if (this.device !is null)
		{
			this.device.release();
			this.device = null;
		}
		return this;
	}

	SDL_GPUTextureFormat getSwapchainTextureFormat()
	in (this.device !is null)
	in (this.device.handle !is null)
	in (this.window !is null)
	in (this.window.handle !is null)
	{
		return SDL_GetGPUSwapchainTextureFormat(this.device.handle, this.window.handle);
	}
}
