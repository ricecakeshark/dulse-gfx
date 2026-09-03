module kelp_gfx.text.render_text;

import kelp_core.graphics;
import kelp_sdl.graphics.command;
import kelp_sdl.graphics.desc;
import kelp_sdl.graphics.resource.texture;

/+ref GpuCommandBuffer render_text(
	ref GpuCommandBuffer command_buffer,
	GfxMesh mesh,
)
{
	scope GpuBufferTransferBuffer buffer;
	buffer.map()
		.set(text_mesh.vertices!(TextureGeometry), text_mesh.offset_vertex,)
		.set(text_mesh.indices!(TextureGeometry), text_mesh.offset_index,)
		.unmap();
	command_buffer.acquire_buffer()
		.copy((pass) {
			pass.upload(
				buffer_transfer_buffer,
				vertex_buffer,
				index_buffer,
			);
			return;
		})
		.submit();
	// render

	command_buffer.acquire_buffer()
		.acquire_texture(swapchain_texture)
		.render((pass) {
			pass
				.bind(pipeline, [vertex_buffer], index_buffer,)
				.push_vert(0, ub_view, ub_model,)
				.push_frag(
					0,
					UniformFragmentConfig(
					ColorF(1.0f, 1.0f, 1.0f, 1.0f),
					ColorF(0.0f, 0.0f, 0.0f, 1.0f),
					ColorF(0.5f, 0.5f, 1.0f, 1.0f),
					0.50f, 0.1f, 0.4f, 0.2f,
				),);
			//
			return;
		});
	return command_buffer;
}+/

ref GpuRenderPass render_text(G)(
	ref GpuRenderPass pass,
	in G[] geometry_list,
	GpuRefTexture[] texture_list,
	GpuSampler sampler,
)
{
	scope uint vertex_offset;
	scope uint index_offset;
	foreach (count; 0..geometry_list.length)
	{
		pass
			.bind([
				GpuTextureSamplerBinding(texture_list[count].handle, sampler.handle)
			])
			.draw_indexed(ParamIndexedPrimitive(
					cast(uint) geometry_list[count].count_index,
					1u, index_offset, vertex_offset, 0u
			));
		vertex_offset += geometry_list[count].count_vertex;
		index_offset += geometry_list[count].count_index;
	}
	return pass;
}
