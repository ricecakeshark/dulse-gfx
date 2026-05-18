module kelp_gfx.graphics_subsystem;

import kelp_gfx;

import kelp_core.core.subsystem;
import kelp_core.core.container.resource_store;

import std.exception;

class GfxGraphicsSubsystem : Subsystem
{
	GfxGraphicsContext _context;

	this()
	{
		
	}

	invariant
	{
		assert(this !is null);
	}

	void initialize()
	{
		this._context = new GfxGraphicsContext();
		return;
	}

	void finalize()
	{
		return;
	}

	void process()
	{
		return;
	}

	@property ref GfxGraphicsContext context()
	{
		enforce(this._context !is null);
		return this._context;
	}
}