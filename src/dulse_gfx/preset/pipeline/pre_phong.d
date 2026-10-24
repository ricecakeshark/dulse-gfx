module dulse_gfx.preset.pipeline.pre_phong;

import dulse_sdl;
import dulse_gfx;

GraphicsContext create_pipeline_phong(
	ref GraphicsContext graphics_context,
	ref ComputePipeline pipeline,
)
{
	graphics_context.create(pipeline);
	auto pipeline_create_info = ComputePipelineCreateInfo(
		ShaderFile("pre_phong.comp", GpuShaderFormat.spirv)
	);
	with (pipeline_create_info)
	{
		//num_readonly_storage_buffers = 0;
		num_samplers = 4;
		num_readwrite_storage_textures = 1;
		num_uniform_buffers = 3;
		threadcount_x = 8;
		threadcount_y = 8;
		threadcount_z = 1;
	}
	pipeline
		.bind(pipeline_create_info)
		.create();
	return graphics_context;
}
