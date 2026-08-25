module kelp_gfx.subsystem;

import kelp_core.core;
import kelp_gfx;

Core append_gio_subsystem(ref Core core)
{
	core.subsystem.append!(
		SDLSubsystem,
		GfxGraphicsSubsystem,
		GfxAudioSubsystem,
		GfxInputSubsystem,
	);
	return core;
}
