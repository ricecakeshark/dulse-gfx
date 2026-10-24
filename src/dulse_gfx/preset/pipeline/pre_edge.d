module dulse_gfx.preset.pipeline.pre_edge;

import dulse_sdl;
import dulse_gfx;

GraphicsContext create_pipeline_pre_edge(
	ref GraphicsContext graphics_context,
	ref ComputePipeline pre_edge_pipeline,
)
{
	graphics_context.create(pre_edge_pipeline);
	//GpuComputePipelineCreateInfo pipeline_create_info;
	auto pipeline_create_info = ComputePipelineCreateInfo(
		ShaderFile("pre_edge.comp", GpuShaderFormat.spirv)
	);
	with (pipeline_create_info)
	{
		//num_readonly_storage_buffers = 0;
		num_samplers = 3;
		num_readwrite_storage_textures = 1;
		num_uniform_buffers = 0;
		threadcount_x = 8;
		threadcount_y = 8;
		threadcount_z = 1;
	}
	pre_edge_pipeline
		.bind(pipeline_create_info)
		.create();
	return graphics_context;
}
