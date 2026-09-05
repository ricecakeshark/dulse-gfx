module dulse_gfx.audio.audio_subsystem;

import dulse_sdl.audio;
import dulse.core.core;
import dulse.core.subsystem;

class GfxAudioSubsystem : Subsystem
{
	this(Core core)
	{
		super(core);
		return;
	}

	typeof(this) initialize()
	{
		return this;
	}

	typeof(this) finalize()
	{
		return this;
	}

	typeof(this) process()
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
