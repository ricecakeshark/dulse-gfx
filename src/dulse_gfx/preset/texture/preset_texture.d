module dulse_gfx.preset.texture.preset_texture;

import dulse_gfx.graphics.desc;
import dulse_gfx.graphics.graphics_context;
import dulse_gfx.graphics.resource;

TexturePreset preset(ref GfxGraphicsContext gc,)
{
	return TexturePreset(gc);
}

struct TexturePreset
{
	GfxGraphicsContext gc;

	this(GfxGraphicsContext gc)
	{
		this.gc = gc;
		return;
	}

	GpuTextureCreateInfo depth()
	{
		return this._depth.apply(gc);
	}

	GpuTextureCreateInfo albedo()
	{
		return this._albedo.apply(gc);
	}

	GpuTextureCreateInfo normal()
	{
		return this._normal.apply(gc);
	}

	GpuTextureCreateInfo material()
	{
		return this._material.apply(gc);
	}

	GpuTextureCreateInfo entity()
	{
		return this._entity.apply(gc);
	}

	GpuTextureCreateInfo color()
	{
		return this._color.apply(gc);
	}

	GpuTextureCreateInfo edge()
	{
		return this._edge.apply(gc);
	}

	enum _depth = GpuTextureCreateInfo(
			GpuTextureType._2d, GpuTextureFormat.d32_float,
			GpuTextureUsageFlags.depth_stencil_target | GpuTextureUsageFlags.sampler,
			0, 0,
		);

	enum _albedo = GpuTextureCreateInfo(
			GpuTextureType._2d, GpuTextureFormat.r8g8b8a8_unorm,
			GpuTextureUsageFlags.sampler | GpuTextureUsageFlags.color_target,
			0, 0, 1, 1,
		);
	enum _normal = GpuTextureCreateInfo(
			GpuTextureType._2d, GpuTextureFormat.r16g16b16a16_float,
			GpuTextureUsageFlags.sampler | GpuTextureUsageFlags.color_target,
			0, 0, 1, 1,
		);
	enum _material = GpuTextureCreateInfo(
			GpuTextureType._2d, GpuTextureFormat.r16g16b16a16_float,
			GpuTextureUsageFlags.sampler | GpuTextureUsageFlags.color_target,
			0, 0, 1, 1,
		);
	enum _entity = GpuTextureCreateInfo(
			GpuTextureType._2d, GpuTextureFormat.r32g32_int,
			GpuTextureUsageFlags.sampler | GpuTextureUsageFlags.color_target,
			0, 0, 1, 1,
		);
	enum _color = GpuTextureCreateInfo(
			GpuTextureType._2d, GpuTextureFormat.r16g16b16a16_float,
			GpuTextureUsageFlags.sampler | GpuTextureUsageFlags.compute_storage_write,
			0, 0, 1, 1,
		);
	enum _edge = GpuTextureCreateInfo(
			GpuTextureType._2d, GpuTextureFormat.r8g8b8a8_unorm,
			GpuTextureUsageFlags.sampler | GpuTextureUsageFlags.compute_storage_write,
			0, 0, 1, 1,
		);
}

GpuTextureCreateInfo apply(GpuTextureCreateInfo info, GfxGraphicsContext gc)
{
	info.width = gc.client_width;
	info.height = gc.client_height;
	return info;
}

enum TexturePresetName
{
	albedo,
	normal,
	material,
	entity,
	color,
	edge,
}
