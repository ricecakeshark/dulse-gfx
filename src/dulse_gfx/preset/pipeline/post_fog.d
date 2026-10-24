module dulse_gfx.preset.pipeline.post_fog;

import dulse_sdl;
import dulse_gfx;

GraphicsContext create_pipeline_post_fog(
	ref GraphicsContext graphics_context,
	ref ComputePipeline post_fog_pipeline,
)
{
	graphics_context.create(post_fog_pipeline);
	//GpuComputePipelineCreateInfo pipeline_create_info;
	auto pipeline_create_info = ComputePipelineCreateInfo(
		ShaderFile("post_fog.comp", GpuShaderFormat.spirv)
	);
	with (pipeline_create_info)
	{
		//num_readonly_storage_buffers = 0;
		num_samplers = 2;
		num_readwrite_storage_textures = 1;
		num_uniform_buffers = 2;
		threadcount_x = 8;
		threadcount_y = 8;
		threadcount_z = 1;
	}
	post_fog_pipeline
		.bind(pipeline_create_info)
		.create();
	return graphics_context;
}
