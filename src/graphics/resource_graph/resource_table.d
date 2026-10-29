module dulse_gfx.graphics.resource_table;

import dulse_sdl.graphics.resource;
import dulse.core.container.interfaced_pool;

import std.exception : enforce;

class GfxResourceTable
{
	GpuGraphicsPipeline[GfxResourceID!GpuGraphicsPipeline] gp_list;
	GpuTexture[GfxResourceID!GpuTexture] texture_list;
	GpuSampler[GfxResourceID!GpuSampler] sampler_list;

	bool has(Type)(GfxResourceID!Type id)
	{
		return this.has_resource(id);
	}

	Type get(Type)(GfxResourceID!Type id)
	{
		return this.lookup(id);
	}

	typeof(this) append(GpuTexture texture) pure nothrow @safe
	{
		return this;
	}

protected:
	bool has_resource(Type)(GfxResourceID!Type id)
	{
		static if (is(Type == GpuTexture))
		{
			return (id in texture_list) !is null;
		}
		else static if (is(Type == GpuSampler))
		{
			return (id in sampler_list) !is null;
		}
		else
		{
			static assert(false, "the resource type(" ~ Type.stringof ~ ") is not supported");
		}
	}

	Type lookup(Type)(GfxResourceID!Type id)
	{
		static if (is(Type == GpuTexture))
		{
			return *enforce(id in texture_list, "texture resource is not found");
		}
		else static if (is(Type == GpuSampler))
		{
			return *enforce(id in sampler_list, "sampler resource is not found");
		}
		else
		{
			static assert(false, "the resource type(" ~ Type.stringof ~ ") is not supported");
		}
	}
}

struct GfxResourceID(Type)
{
	ulong id;
}

unittest
{
	import std.exception;

	GfxResourceTable resource_table;
	resource_table = new GfxResourceTable();
	assert(!resource_table.has(GfxResourceID!GpuTexture(0)));
	assert(!resource_table.has(GfxResourceID!GpuSampler(0)));
	assert(!resource_table.has(GfxResourceID!GpuSampler(0)));
	assert(collectException(resource_table.get(GfxResourceID!GpuSampler(0))));
}
