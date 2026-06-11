module kelp_gfx.sdl.sdl_subsystem;

import kelp_core.core;
import kelp_core.logger;
import kelp_sdl.core;

import std.format;

class SDLSubsystem : Subsystem
{
	protected LibrarySDL sdl;
	protected LibrarySDLImage sdl_image;
	protected LibrarySDLTTF sdl_ttf;
	protected LibrarySDLMixer sdl_mixer;
	protected LoggerSubsystem logger;
	public bool initialized = false;

	this(Core core)
	{
		super(core);
		sdl = new LibrarySDL();
		sdl_image = new LibrarySDLImage();
		sdl_ttf = new LibrarySDLTTF();
		sdl_mixer = new LibrarySDLMixer();
		return;
	}

	typeof(this) initialize()
	{
		if (initialized == true)
		{
			return this;
		}
		initialized = true;
		this.core.subsystem.query(this.logger);
		sdl.initialize();
		logger.log(
			format(
				"SDL3 (linked:%s compiled:%s)",
				cast(string)(sdl.linked_version),
				cast(string)(sdl.compiled_version)
		)
		);
		sdl_image.initialize();
		logger.log(
			format(
				"SDL3_image (linked:%s compiled:%s)",
				cast(string)(sdl_image.compiled_version),
				cast(string)(sdl_image.linked_version)
		)
		);
		sdl_ttf.initialize();
		logger.log(
			format(
				"SDL3_ttf (linked:%s compiled:%s)",
				cast(string)(sdl_ttf.compiled_version),
				cast(string)(sdl_ttf.linked_version)
		)
		);
		sdl_mixer.initialize();
		logger.log(
			format(
				"SDL3_mixer (linked:%s compiled:%s)",
				cast(string)(sdl_mixer.compiled_version),
				cast(string)(sdl_mixer.linked_version)
		)
		);
		return this;
	}

	typeof(this) finalize()
	{
		//sdl_mixer.finalize();
		sdl_ttf.finalize();
		sdl_image.finalize();
		sdl.finalize();
		return this;
	}

	typeof(this) process()
	{
		return this;
	}
}
