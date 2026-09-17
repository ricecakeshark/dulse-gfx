module dulse_gfx.sdl.sdl_subsystem;

import dulse.core;
import dulse.logger;
import dulse_sdl.core;
import std.format : format;

class SDLSubsystem : Subsystem!SDLSubsystem
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

	override typeof(this) initialize()
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
				sdl.linked_version.to_string(),
				sdl.compiled_version.to_string()
		)
		);
		sdl_image.initialize();
		logger.log(
			format(
				"SDL3_image (linked:%s compiled:%s)",
				sdl_image.compiled_version.to_string(),
				sdl_image.linked_version.to_string()
		)
		);
		sdl_ttf.initialize();
		logger.log(
			format(
				"SDL3_ttf (linked:%s compiled:%s)",
				sdl_ttf.compiled_version.to_string(),
				sdl_ttf.linked_version.to_string()
		)
		);
		sdl_mixer.initialize();
		logger.log(
			format(
				"SDL3_mixer (linked:%s compiled:%s)",
				sdl_mixer.compiled_version.to_string(),
				sdl_mixer.linked_version.to_string()
		)
		);
		return this;
	}

	override typeof(this) finalize()
	{
		sdl_mixer.finalize();
		sdl_ttf.finalize();
		sdl_image.finalize();
		sdl.finalize();
		return this;
	}

	override typeof(this) process()
	{
		return this;
	}
}
