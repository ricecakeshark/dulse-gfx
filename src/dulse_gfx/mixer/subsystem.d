module dulse_gfx.mixer.subsystem;

import dulse.core.subsystem;
import dulse_sdl.mixer;
import dulse.core.core;
import std.exception : enforce;

debug import std.stdio;

class MixerSubsystem : Subsystem!MixerSubsystem
{
	Mixer mixer;
	Track track;
	//Audio[] audio_list;

	this(Core core)
	{
		super(core);
		return;
	}

	override typeof(this) initialize()
	{
		mixer = new Mixer();
		mixer.create();
		//track = new Track(mixer);
		//track.create();
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

	typeof(this) create(TypeList...)(ref TypeList list)
	in (this.mixer.is_valid)
	{
		foreach (ref elm; list)
		{
			this.create(elm);
		}
		return this;
	}

	typeof(this) create(ref Track track)
	in (this.mixer.is_valid)
	{
		if (track !is null)
		{
			return this;
		}
		track = new Track(this.mixer)
			.create();
		return this;
	}

	typeof(this) create(ref Audio audio)
	in (this.mixer.is_valid)
	{
		if (audio !is null)
		{
			return this;
		}
		audio = new Audio(this.mixer);
		return this;
	}
}
