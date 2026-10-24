module dulse_gfx.preset.pipeline.post_edge;

import dulse_sdl;
import dulse_gfx;

GraphicsContext create_pipeline_post_edge(
	ref GraphicsContext graphics_context,
	ref ComputePipeline post_edge_pipeline,
)
{
	graphics_context.create(post_edge_pipeline);
	//GpuComputePipelineCreateInfo pipeline_create_info;
	auto pipeline_create_info = ComputePipelineCreateInfo(
		ShaderFile("post_edge.comp", GpuShaderFormat.spirv)
	);
	with (pipeline_create_info)
	{
		//num_readonly_storage_buffers = 0;
		num_samplers = 1;
		num_readwrite_storage_textures = 1;
		num_uniform_buffers = 1;
		threadcount_x = 8;
		threadcount_y = 8;
		threadcount_z = 1;
	}
	post_edge_pipeline
		.bind(pipeline_create_info)
		.create();
	return graphics_context;
}
