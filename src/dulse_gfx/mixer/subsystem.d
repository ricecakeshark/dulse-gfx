module dulse_gfx.mixer.subsystem;

import dulse.core.subsystem;
import dulse_sdl.mixer;
import dulse.core.core;
import std.exception : enforce;

class MixerSubsystem : Subsystem
{
	Mixer mixer;
	Track track;
	Audio[] audio_list;

	this(Core core)
	{
		super(core);
		return;
	}

	typeof(this) initialize()
	{
		mixer = new Mixer();
		mixer.create();
		track = new Track(mixer);
		track.create();
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

	typeof(this) open(string path)
	{
		this.audio_list ~= new Audio(this.mixer)
			.load(path);
		return this;
	}

	typeof(this) set(size_t index)
	{
		enforce(index < audio_list.length);
		this.track.set(audio_list[index]);
		return this;
	}

	typeof(this) play()
	{
		this.track.play();
		return this;
	}
}
