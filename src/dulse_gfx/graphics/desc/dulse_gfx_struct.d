module dulse_gfx.graphics.desc.dulse_gfx_struct;

import dulse_sdl.graphics.resource;

struct GfxCopyBufferSequence
{
	GpuBufferTransferBuffer bt_buffer;
	GpuBuffer[] buffer_list;

	this(GpuBufferTransferBuffer bt_buffer, GpuBuffer[] buffer_list...)
	{
		this.bt_buffer = bt_buffer;
		this.buffer_list = buffer_list;
		return;
	}
}

GfxCopyBufferSequence sequence(
	GpuBufferTransferBuffer bt_buffer,
	GpuBuffer[] buffer_list...
)
{
	return GfxCopyBufferSequence(bt_buffer, buffer_list);
}

struct GfxCopyTextureSequence
{
	GpuTextureTransferBuffer tt_buffer;
	GpuTexture[] texture_list;

	this(GpuTextureTransferBuffer tt_buffer, GpuTexture[] texture_list...)
	{
		this.tt_buffer = tt_buffer;
		this.texture_list = texture_list;
		return;
	}
}

GfxCopyTextureSequence sequence(GpuTextureTransferBuffer tt_buffer, GpuTexture[] texture_list...)
{
	return GfxCopyTextureSequence(tt_buffer, texture_list);
}
