module kelp_gfx.graphics.vertex_input_state;

import kelp_sdl;

GpuGraphicsPipelineCreateInfo vertex_input_state(TypeList...)()
{
	GpuVertexInputState vertex_input_state;
	vertex_input_state = GpuVertexInputState(
		[
			vertex_buffer_description!(TypeList)()
		],
		vertex_attributes!(TypeList)(0),
	);
	return vertex_input_state.dup;
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
