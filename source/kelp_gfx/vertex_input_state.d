module kelp_gfx.vertex_input_state;

import kelp_sdl;

GpuGraphicsPipelineCreateInfo pipeline_create_info(TypeList...)()
{
	GpuGraphicsPipelineCreateInfo pipeline_create_info;
	GpuVertexAttribute[] attribute_list;
	uint offset;

	foreach (count, Type; TypeList)
	{
		attribute_list ~= attributes!(TypeList[count])(0, count, offset);
		offset += Type.sizeof;
	}

	with (pipeline_create_info)
	{
		vertex_input_state = GpuVertexInputState(
			[
			GpuVertexBufferDescription(
				0,
				float.sizeof * 7,
				GpuVertexInputRate.vertex,
				0
			)
		],
		attribute_list,
		);
		primitive_type = SDL_GPU_PRIMITIVETYPE_TRIANGLELIST;
		target_info = GpuGraphicsPipelineTargetInfo(
			[
			GpuColorTargetDescription(
				graphics_context.get_swapchain_texture_format()
			)
		]
		);
	}
	return pipeline_create_info.dup;
}

GpuVertexBufferDescription vertex_buffer_description(TypeList...)()
{
	uint size;
	foreach (Type; TypeList)
	{
		size += Type.sizeof;
	}
	return GpuVertexBufferDescription(
		0,
		size,
		GpuVertexInputRate.vertex,
		0
	);
}

GpuVertexAttribute[] vertex_attributes(TypeList...)(
	uint buffer_slot,
)
{
	GpuVertexAttribute[] attribute_list;
	uint offset;
	foreach (count, Type; TypeList)
	{
		attribute_list ~= vertex_attribute!(Type)(buffer_slot, count, offset);
		offset += Type.sizeof;
	}
	return attribute_list.dup;
}

GpuVertexAttribute vertex_attribute(Type : float[N], size_t N)(
	uint buffer_slot,
	uint location,
	uint offset,
)
{
	static if (N == 2)
	{
		return GpuVertexAttribute(
			location, buffer_slot, GpuVertexElementFormat.float2, offset,
		);
	}
	else static if (N == 3)
	{
		return GpuVertexAttribute(
			location, buffer_slot, GpuVertexElementFormat.float3, offset,
		);
	}
	else static if (N == 4)
	{
		return GpuVertexAttribute(
			location, buffer_slot, GpuVertexElementFormat.float4, offset,
		);
	}
}
