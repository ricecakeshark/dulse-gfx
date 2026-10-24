module dulse_gfx.graphics.command.copy_pass;

import dulse.graphics : GfxGeometry;
import dulse_sdl.graphics.command;

/+
void upload(G : GfxGeometry!(V, I),V,I)(ref GpuCopyPass copy_pass)
{
	copy_pass
		.upload(
			GpuTransferBufferLocation(buffer_transfer_buffer, object_geometry.offset_vertex),
			GpuBufferRegion(vertex_buffer, 0u)
		);
	copy_pass.upload(
		GpuTransferBufferLocation(buffer_transfer_buffer, object_geometry.offset_index),
		GpuBufferRegion(index_buffer, 0u)
	);
	return;
}
+/