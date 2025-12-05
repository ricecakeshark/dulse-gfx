module kelp_render.graphics_context;

import bindbc.sdl;
import kelp_sdl;
import kelp_render;

class GPUGraphicsContext
{
	public GPUDevice device;
	public GPUWindow window;

	protected GPUGraphicsPipeline[] graphics_pipeline_list;
	protected GPUVertexBuffer[] vertex_buffer_list;
	protected GPUIndexBuffer[] index_buffer_list;

	this()
	{

		return;
	}

	~this()
	{
		this.release_listed();
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

	typeof(this) release_listed()
	{
		// GraphicsPipeline
		foreach (index; 0 .. graphics_pipeline_list.length)
		{
			if (graphics_pipeline_list[index] is null)
			{
				continue;
			}
			graphics_pipeline_list[index].release();
			destroy(graphics_pipeline_list[index]);
		}
		graphics_pipeline_list = [];
		// vertex_buffer
		foreach (index; 0 .. vertex_buffer_list.length)
		{
			if (vertex_buffer_list[index] is null)
			{
				continue;
			}
			vertex_buffer_list[index].release();
			destroy(vertex_buffer_list[index]);
		}
		vertex_buffer_list = [];
		//index_buffer
		foreach (index; 0 .. index_buffer_list.length)
		{
			if (index_buffer_list[index] is null)
			{
				continue;
			}
			index_buffer_list[index].release();
			destroy(index_buffer_list[index]);
		}
		index_buffer_list = [];
		return this;
	}

	GPUGraphicsPipeline createGraphicsPipline()
	{
		GPUGraphicsPipeline temp_graphics_pipeline;
		temp_graphics_pipeline = new GPUGraphicsPipeline(this.device);
		graphics_pipeline_list ~= temp_graphics_pipeline;
		return temp_graphics_pipeline;
	}

	GPUVertexBuffer createVertexBuffer()
	{
		GPUVertexBuffer temp_vertex_buffer;
		temp_vertex_buffer = new GPUVertexBuffer(this.device);
		vertex_buffer_list ~= temp_vertex_buffer;
		return temp_vertex_buffer;
	}

	GPUIndexBuffer createIndexBuffer()
	{
		GPUIndexBuffer temp_index_buffer;
		temp_index_buffer = new GPUIndexBuffer(this.device);
		index_buffer_list ~= temp_index_buffer;
		return temp_index_buffer;
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
