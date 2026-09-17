module dulse_gfx.audio.audio_subsystem;

import dulse_sdl.audio;
import dulse.core.core;
import dulse.core.subsystem;

class AudioSubsystem : Subsystem!AudioSubsystem
{
	this(Core core)
	{
		super(core);
		return;
	}

	override typeof(this) initialize()
	{
		return this;
	}

	override typeof(this) finalize()
	{
		return this;
	}

	override typeof(this) process()
	{
		return this;
	}

	AudioDevice open_device()
	{
		return new AudioDevice();
	}

	AudioStream create_stream()
	{
		return new AudioStream();
	}
}
