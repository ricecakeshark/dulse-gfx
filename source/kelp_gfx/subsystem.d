module kelp_gfx.subsystem;

import kelp_core.core;
import kelp_gfx;

Core append_gio_subsystem(ref Core core)
{
	core.subsystem.append(
		new SDLSubsystem(core),
		new GfxDeviceSubsystem(core),
		new GfxEventSubsystem(core),
		new GfxGraphicsSubsystem(core),
		new GfxAudioSubsystem(core),
	);
	return core;
}
