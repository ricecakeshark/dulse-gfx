module kelp_render.render_context;

import kelp_sdl;

class GPURenderContext
{
	GPUCommandBuffer command_buffer;
	GPURenderPass render_pass;
	GPUSwapchainTexture swapchain_texture;
	bool renderable;

	this(GPUDevice device, GPUWindow window)
	{
		this.command_buffer = new GPUCommandBuffer(device);
		this.render_pass = new GPURenderPass();
		this.swapchain_texture = new GPUSwapchainTexture(device, window);
		return;
	}

	~this()
	{
		this.command_buffer = null;
		this.render_pass = null;
		this.swapchain_texture = null;
		return;
	}

public:
	typeof(this) acquire()
	{
		this.renderable = false;
		this.command_buffer.acquire();
		if (this.command_buffer.handle is null)
		{
			return this;
		}
		this.swapchain_texture.acquire(this.command_buffer);
		if (this.swapchain_texture.handle is null)
		{
			return this;
		}
		this.renderable = true;
		return this;
	}

	typeof(this) submit()
	{
		this.command_buffer.submit();
		return this;
	}

	typeof(this) begin(GPUColorTargetInfo[] color_target_info_list)
	in (color_target_info_list.length >= 1)
	{
		if (!this.renderable)
		{
			return this;
		}
		this.render_pass.begin(this.command_buffer, color_target_info_list);
		return this;
	}

	typeof(this) begin(
		GPUColorTargetInfo[] color_target_info_list,
		GPUDepthStencilTargetInfo depth_stencil_target_info
	)
	in (color_target_info_list.length >= 1)
	{
		if (!this.renderable)
		{
			return this;
		}
		this.render_pass.begin(
			this.command_buffer,
			color_target_info_list,
			depth_stencil_target_info
		);
		return this;
	}

	typeof(this) end()
	{
		if (!this.renderable)
		{
			return this;
		}
		this.render_pass.end();
		return this;
	}

	typeof(this) render(void delegate() dlg)
	{
		if (!this.renderable)
		{
			return this;
		}
		dlg();
		return this;
	}

	typeof(this) bind(GPUVertexBuffer[] vertex_buffer_list, uint first_slot = 0)
	{
		if (!this.renderable)
		{
			return this;
		}
		this.render_pass.bind(vertex_buffer_list, first_slot);
		return this;
	}

	typeof(this) bind(GPUIndexBuffer index_buffer)
	{
		if (!this.renderable)
		{
			return this;
		}
		this.render_pass.bind(index_buffer);
		return this;
	}

	typeof(this) if_acquired(void delegate() dlg)
	{
		if (this.swapchain_texture.handle is null)
		{
			return this;
		}
		dlg();
		return this;
	}
	/+typeof(this) bind(GPUTextureSamplerBinding[] binding_list, uint first_slot = 0)
	{
		if(!this.renderable)
		{
			return this;
		}
		this.render_pass.bind(binding_list,first_slot);
		return this;
	}+/

	/+typeof(this) drawIndexedPrimitive(
		uint num_vertices,
		uint num_instance,
		uint first_vertex,
		int vertex_offset,
		uint first_instance,
	){
		if(!this.renderable)
		{
			return this;
		}
		this.render_pass.drawIndexedPrimitive(
			num_vertices,
			num_instance,
			first_vertex,
			vertex_offset,
			first_instance,
		);
		return this;
	}+/

	/+
	typeof(this) blit(GPUBlitInfo blit_info)
	{
		if(!this.renderable)
		{
			return this;
		}
		this.command_buffer.blitTexture(blit_info);
		return this;
	}
	+/
}
