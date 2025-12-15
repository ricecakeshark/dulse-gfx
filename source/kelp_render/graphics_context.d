module kelp_render.graphics_context;

import bindbc.sdl;
import kelp_sdl;
import kelp_render;

class GPUGraphicsContext
{
	public GPUDevice device;
	public GPUWindow window;

	protected GPUGraphicsPipeline[] graphics_pipeline_list;
	protected GPUVertexShader[] vertex_shader_list;
	protected GPUFragmentShader[] fragment_shader_list;
	protected GPUVertexBuffer[] vertex_buffer_list;
	protected GPUIndexBuffer[] index_buffer_list;
	protected GPUTexture[] texture_list;
	protected GPUSampler[] sampler_list;

	this()
	{

		return;
	}

	~this()
	{
		this.release_all();
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

	typeof(this) release_all()
	{
		this.release_vertex_shader();
		this.release_fragment_shader();
		this.release_graphics_pipeline();
		this.release_vertex_buffer();
		this.release_index_buffer();
		this.release_texture();
		this.release_sampler();
		return this;
	}

	typeof(this) release_all_shader()
	{
		this.release_vertex_shader();
		this.release_fragment_shader();
		return this;
	}

	typeof(this) release_all_buffer()
	{
		this.release_vertex_buffer();
		this.release_index_buffer();
		return this;
	}

	GPUVertexShader create_vertex_shader()
	{
		GPUVertexShader temp;
		temp = new GPUVertexShader(this.device);
		this.vertex_shader_list ~= temp;
		return temp;
	}

	typeof(this) release_vertex_shader()
	{
		foreach (index; 0 .. vertex_shader_list.length)
		{
			if (vertex_shader_list[index] is null)
			{
				continue;
			}
			vertex_shader_list[index].release();
			destroy(vertex_shader_list[index]);
		}
		vertex_shader_list = [];
		return this;
	}

	GPUFragmentShader create_fragment_shader()
	{
		GPUFragmentShader temp;
		temp = new GPUFragmentShader(this.device);
		this.fragment_shader_list ~= temp;
		return temp;
	}

	typeof(this) release_fragment_shader()
	{
		foreach (index; 0 .. fragment_shader_list.length)
		{
			if (fragment_shader_list[index] is null)
			{
				continue;
			}
			fragment_shader_list[index].release();
			destroy(fragment_shader_list[index]);
		}
		fragment_shader_list = [];
		return this;
	}

	GPUGraphicsPipeline create_graphics_pipeline()
	{
		GPUGraphicsPipeline temp_graphics_pipeline;
		temp_graphics_pipeline = new GPUGraphicsPipeline(this.device);
		graphics_pipeline_list ~= temp_graphics_pipeline;
		return temp_graphics_pipeline;
	}

	typeof(this) release_graphics_pipeline()
	{
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
		return this;
	}

	GPUVertexBuffer create_vertex_buffer()
	{
		GPUVertexBuffer temp_vertex_buffer;
		temp_vertex_buffer = new GPUVertexBuffer(this.device);
		vertex_buffer_list ~= temp_vertex_buffer;
		return temp_vertex_buffer;
	}

	typeof(this) release_vertex_buffer()
	{
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
		return this;
	}

	GPUIndexBuffer create_index_buffer()
	{
		GPUIndexBuffer temp_index_buffer;
		temp_index_buffer = new GPUIndexBuffer(this.device);
		index_buffer_list ~= temp_index_buffer;
		return temp_index_buffer;
	}

	typeof(this) release_index_buffer()
	{
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

	GPUTexture create_texture()
	{
		GPUTexture temp_texture;
		temp_texture = new GPUTexture(this.device);
		texture_list ~= temp_texture;
		return temp_texture;
	}

	typeof(this) release_texture()
	{
		foreach (index; 0 .. texture_list.length)
		{
			if (texture_list[index] is null)
			{
				continue;
			}
			texture_list[index].release();
			destroy(texture_list[index]);
		}
		texture_list = [];
		return this;
	}

	GPUSampler create_sampler()
	{
		GPUSampler temp_sampler;
		temp_sampler = new GPUSampler(this.device);
		sampler_list ~= temp_sampler;
		return temp_sampler;
	}

	typeof(this) release_sampler()
	{
		foreach (index; 0 .. sampler_list.length)
		{
			if (sampler_list[index] is null)
			{
				continue;
			}
			sampler_list[index].release();
			destroy(sampler_list[index]);
		}
		sampler_list = [];
		return this;
	}

	GPUUploadContext create_upload_context()
	{
		return new GPUUploadContext(this.device);
	}

	GPURenderContext create_render_context()
	{
		return new GPURenderContext(this.device, this.window);
	}

	bool support_format(
		SDL_GPUTextureFormat format,
		SDL_GPUTextureType type,
		SDL_GPUTextureUsageFlags usage
	)
	in (this.device !is null)
	in (this.device.handle !is null)
	{
		return this.device.supportFormat(format, type, usage);
	}

	GPUTextureFormat get_swapchain_texture_format()
	in (this.device !is null)
	in (this.device.handle !is null)
	in (this.window !is null)
	in (this.window.handle !is null)
	{
		return cast(GPUTextureFormat) SDL_GetGPUSwapchainTextureFormat(
			this.device.handle, this.window.handle
		);
	}

	private Class create_in_list(Class, alias List)()
	{
		Class temp;
		temp = new Class(this.device);
		this.List ~= temp;
		return temp;
	}

	private typeof(this) release_list(alias List)()
	{
		foreach (index; 0 .. List.length)
		{
			if (List[index] is null)
			{
				continue;
			}
			List[index].release();
			destroy(List[index]);
		}
		List = [];
		return this;
	}
}
