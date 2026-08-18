module kelp_gfx.subsystem;

import kelp_core.core;
import kelp_core.input.input_subsystem;
import kelp_gfx;

//import kelp_gfx.event.event_subsystem;
import std.stdio;

Core append_gio_subsystem(ref Core core)
{
	core.subsystem.append(
		new SDLSubsystem(core),
		new GfxGraphicsSubsystem(core),
		new GfxAudioSubsystem(core),
	);
	if (core.subsystem.query!InputSubsystem() !is null)
	{
		core.subsystem.query!InputSubsystem().register_poller(
			() { return poll_sdl_event(); }
		);
	}
	else
	{
		assert(0);
	}
	return core;
}
