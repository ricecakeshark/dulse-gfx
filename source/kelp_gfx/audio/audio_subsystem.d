module kelp_gfx.audio.audio_subsystem;

import kelp_sdl.audio;
import kelp_core.core.core;
import kelp_core.core.subsystem;

class AudioSubsystem : Subsystem
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
