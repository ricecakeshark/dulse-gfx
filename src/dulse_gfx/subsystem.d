module dulse_gfx.subsystem;

import dulse.core;
import dulse_gfx;
import std.meta:AliasSeq;

Core append_gio_subsystem(ref Core core)
{
	core.subsystem.append!(
		SDLSubsystem,
		GraphicsSubsystem,//GfxAudioSubsystem,
		MixerSubsystem,
		InputSubsystem,
		ActionSubsystem,
	);
	return core;
}

alias GfxSubsystemList = AliasSeq!(
	SDLSubsystem, GraphicsSubsystem, MixerSubsystem, InputSubsystem, ActionSubsystem,
);
//core.subsystem.appned!GfxSubsytemList();