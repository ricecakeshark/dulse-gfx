module kelp_gfx.graphics;

/+
version (Windows)
{
	import core.sys.windows.dll;

	mixin SimpleDllMain;
}
+/

import kelp_core.core.subsystem;
import kelp_sdl;
import kelp_render;

//import kelp_core;
import bindbc.sdl;
/+
class SDLGraphicsSubsystem : Subsystem
{
	GpuDevice[] device_list;
	GpuWindow[] window_list;
	Object[] object_list;

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

	GpuDevice createDevice()
	{
		GpuDevice temp_device;
		temp_device = new GpuDevice();
		this.device_list ~= temp_device;
		return temp_device;
	}

	GpuDevice createWindow()
	{
		GpuDevice temp_device;
		temp_device = new GpuDevice();
		this.device_list ~= temp_device;
		return temp_device;
	}

	GpuGraphicsPipeline createGraphicsPipeline(GpuDevice device)
	{
		GpuGraphicsPipeline temp_pipeline;
		temp_pipeline = new GpuGraphicsPipeline(device);
		this.object_list ~= temp_pipeline;
		return temp_pipeline;
	}

	GpuVertexBuffer createVertexBuffer(GpuDevice device)
	{
		GpuVertexBuffer temp_buffer;
		temp_buffer = new GpuVertexBuffer(device);
		this.object_list ~= temp_buffer;
		return temp_buffer;
	}

	GfxRenderContext createRenderContext(GpuDevice device, GpuWindow window)
	{
		GfxRenderContext temp_context;
		temp_context = new GfxRenderContext(device, window);
		//this.releasable_object_list ~= temp_context;
		return temp_context;
	}

	GfxUploadContext createUploadContext(GpuDevice device)
	{
		GfxUploadContext temp_context;
		temp_context = new GfxUploadContext(device);
		//releasable_object_list ~= temp_context;
		return temp_context;
	}
}
+/