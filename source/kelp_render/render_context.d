module kelp_render.render_context;

import kelp_sdl;

class GPURenderContext
{
	GPUCommandBuffer command_buffer;
	GPURenderPass render_pass;
	GPUSwapchainTexture swapchain_texture;

	this(GPUDevice device, GPUWindow window)
	{
		this.command_buffer = new GPUCommandBuffer(device);
		this.render_pass = new GPURenderPass();
		this.swapchain_texture = new GPUSwapchainTexture(device, window);
		return;
	}

	~this()
	{

		return;
	}

public:
	typeof(this) acquire_buffer()
	{
		this.command_buffer.acquire_buffer();
		return this;
	}

	typeof(this) acquire_texture()
	{
		this.swapchain_texture.acquire(this.command_buffer);
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

	typeof(this) release()
	{
		this.command_buffer = null;
		this.render_pass = null;
		this.swapchain_texture = null;
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
		if (this.swapchain_texture.handle is null)
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
		if (this.swapchain_texture.handle is null)
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
		if (this.swapchain_texture.handle is null)
		{
			return this;
		}
		this.render_pass.end();
		return this;
	}

	typeof(this) bind(GPUGraphicsPipeline pipeline)
	in (pipeline !is null)
	in (pipeline.handle !is null)
	{
		this.render_pass.bind(pipeline);
		return this;
	}

	typeof(this) bind(GPUVertexBuffer[] vertex_buffer_list, uint first_slot = 0)
	{
		if (this.swapchain_texture.handle is null)
		{
			return this;
		}
		this.render_pass.bind(vertex_buffer_list, first_slot);
		return this;
	}

	typeof(this) bind(GPUIndexBuffer index_buffer)
	{
		if (this.swapchain_texture.handle is null)
		{
			return this;
		}
		this.render_pass.bind(index_buffer);
		return this;
	}

	typeof(this) bind(GPUTexture[] texture_list, uint first_slot = 0u)
	{
		this.render_pass.bind(texture_list, first_slot);
		return this;
	}

	typeof(this) bind(GPUTextureSamplerBinding[] texture_sampler_binding, uint first_slot = 0)
	{
		if (this.swapchain_texture.handle is null)
		{
			return this;
		}
		this.render_pass.bind(texture_sampler_binding, first_slot);
		return this;
	}

	typeof(this) draw(
		ParamPrimitive param
	)
	{
		if (this.swapchain_texture.handle is null)
		{
			return this;
		}
		this.render_pass.draw(param);
		return this;
	}

	typeof(this) draw_indexed(
		ParamIndexedPrimitive param
	)
	{
		if (this.swapchain_texture.handle is null)
		{
			return this;
		}
		this.render_pass.draw_indexed(param);
		return this;
	}

	@disable typeof(this) draw_indirect(
		GPUDrawBuffer draw_buffer, ParamPrimitiveIndirect param
	)
	{
		if (this.swapchain_texture.handle is null)
		{
			return this;
		}
		this.render_pass.draw_indirect(draw_buffer, param);
		return this;
	}

	@disable typeof(this) draw_indexed_indirect(
		GPUDrawBuffer draw_buffer, ParamPrimitiveIndirect param
	)
	{
		if (this.swapchain_texture.handle is null)
		{
			return this;
		}
		this.render_pass.draw_indexed_indirect(draw_buffer, param);
		return this;
	}

	typeof(this) set(const GPUViewport viewport)
	{
		this.render_pass.set(viewport);
		return this;
	}

	typeof(this) set(const Rect scissor_rect)
	{
		this.render_pass.set(scissor_rect);
		return this;
	}

	typeof(this) set(ubyte stencil_reference)
	{
		this.render_pass.set(stencil_reference);
		return this;
	}

	typeof(this) push_vertex(Type)(Type uniform_data, uint first_slot)
	{
		this.command_buffer.push_vertex(uniform_data, first_slot);
		return this;
	}

	typeof(this) push_fragment(Type)(Type uniform_data, uint first_slot)
	{
		this.command_buffer.push_fragment(uniform_data, first_slot);
		return this;
	}

	typeof(this) blit(GPUBlitInfo blit_info)
	{
		if (this.swapchain_texture.handle is null)
		{
			return this;
		}
		this.command_buffer.blit_texture(blit_info);
		return this;
	}
}
