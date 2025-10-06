module kelp_render.graphics;

/+
version (Windows)
{
	import core.sys.windows.dll;

	mixin SimpleDllMain;
}
+/

import kelp_api;
import kelp_sdl;
import kelp_render;

//import kelp_core;
import bindbc.sdl;

//export extern(C):

class SDLGraphicsSubsystem : Subsystem
{

	this()
	{
		return;
	}

	void initialize()
	{
		return;
	}

	void finalize()
	{
		return;
	}

	void process()
	{
		return;
	}

	GPURenderContext createRenderContext(GPUDevice device, GPUWindow window)
	{
		return new GPURenderContext(device, window);
	}

	GPUUploadContext createRenderContext(GPUDevice device)
	{
		return new GPUUploadContext(device);
	}
}
