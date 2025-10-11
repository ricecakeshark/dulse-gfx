module kelp_render.graphics;

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

//export extern(C):

class SDLGraphicsSubsystem : Subsystem
{
	GPUDevice[] device_list;
	GPUWindow[] window_list;
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

	GPUDevice createDevice()
	{
		GPUDevice temp_device;
		temp_device = new GPUDevice();
		this.device_list ~= temp_device;
		return temp_device;
	}

	GPUDevice createWindow()
	{
		GPUDevice temp_device;
		temp_device = new GPUDevice();
		this.device_list ~= temp_device;
		return temp_device;
	}

	GPUGraphicsPipeline createGraphicsPipeline(GPUDevice device)
	{
		GPUGraphicsPipeline temp_pipeline;
		temp_pipeline = new GPUGraphicsPipeline(device);
		this.object_list ~= temp_pipeline;
		return temp_pipeline;
	}

	GPUVertexBuffer createVertexBuffer(GPUDevice device)
	{
		GPUVertexBuffer temp_buffer;
		temp_buffer = new GPUVertexBuffer(device);
		this.object_list ~= temp_buffer;
		return temp_buffer;
	}

	GPURenderContext createRenderContext(GPUDevice device, GPUWindow window)
	{
		GPURenderContext temp_context;
		temp_context = new GPURenderContext(device, window);
		//this.releasable_object_list ~= temp_context;
		return temp_context;
	}

	GPUUploadContext createUploadContext(GPUDevice device)
	{
		GPUUploadContext temp_context;
		temp_context = new GPUUploadContext(device);
		//releasable_object_list ~= temp_context;
		return temp_context;
	}
}
