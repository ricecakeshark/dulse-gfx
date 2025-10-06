module kelp_render.upload_context;

import kelp_sdl.graphics.command;
import kelp_sdl.graphics.core.gpu_device;
import kelp_sdl.graphics.resource.buffer;

class GPUUploadContext
{
	GPUCommandBuffer command_buffer;
	GPUCopyPass copy_pass;
	GPUBufferTransferBuffer buffer_transfer_buffer;
	//GPUTextureTransferBuffer texture_transfer_buffer;

	this(GPUDevice device)
	{
		this.command_buffer = new GPUCommandBuffer(device);
		this.copy_pass = new GPUCopyPass();
		this.buffer_transfer_buffer = new GPUBufferTransferBuffer(device);
		//this.texture_transfer_buffer = new GPUTextureTransferBuffer(device);
		return;
	}

	~this()
	{
		return;
	}

	typeof(this) release()
	{
		this.command_buffer = null;
		this.copy_pass = null;
		this.buffer_transfer_buffer = null;
		// this.texture_transfer_buffer = null;
		return this;
	}

	typeof(this) begin()
	{
		this.command_buffer.acquire();
		this.copy_pass.begin(this.command_buffer);
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

	typeof(this) upload(GPUVertexBuffer vertex_buffer)
	in (vertex_buffer.handle !is null)
	{
		this.buffer_transfer_buffer.create(vertex_buffer.sizeInBytes)
			.map()
			.set(vertex_buffer.data)
			.unmap();
		this.copy_pass.upload(buffer_transfer_buffer, vertex_buffer, 0);
		return this;
	}

	typeof(this) upload(
		GPUVertexBuffer vertex_buffer,
		GPUIndexBuffer index_buffer,
	)
	in (vertex_buffer.handle !is null)
	in (index_buffer.handle !is null)
	{
		this.buffer_transfer_buffer.create(vertex_buffer.sizeInBytes + index_buffer.sizeInBytes)
			.map()
			.set(vertex_buffer.data ~ index_buffer.data)
			.unmap();
		this.copy_pass.upload(buffer_transfer_buffer, vertex_buffer, 0)
			.upload(buffer_transfer_buffer, index_buffer, vertex_buffer.sizeInBytes);
		return this;
	}

	typeof(this) upload(
		GPUVertexBuffer vertex_buffer,
		GPUIndexBuffer index_buffer,
		GPUDrawBuffer draw_buffer,
	)
	in (vertex_buffer.handle !is null)
	in (index_buffer.handle !is null)
	in (draw_buffer.handle !is null)
	{
		this.buffer_transfer_buffer.create(
			vertex_buffer.sizeInBytes + index_buffer.sizeInBytes + draw_buffer.sizeInBytes
		)
			.map()
			.set(vertex_buffer.data ~ index_buffer.data ~ draw_buffer.data)
			.unmap();
		this.copy_pass.upload(buffer_transfer_buffer, vertex_buffer, 0)
			.upload(buffer_transfer_buffer, index_buffer, vertex_buffer.sizeInBytes)
			.upload(buffer_transfer_buffer, draw_buffer, vertex_buffer.sizeInBytes + index_buffer
					.sizeInBytes);
		return this;
	}
}
