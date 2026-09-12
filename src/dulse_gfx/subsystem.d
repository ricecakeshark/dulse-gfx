module dulse_gfx.subsystem;

import dulse.core;
import dulse_gfx;

Core append_gio_subsystem(ref Core core)
{
	core.subsystem.append!(
		SDLSubsystem,
		GfxGraphicsSubsystem,
		//GfxAudioSubsystem,
		MixerSubsystem,
		GfxInputSubsystem,
	);
	return core;
}
