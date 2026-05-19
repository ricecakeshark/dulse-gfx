module kelp_gfx.subsystem.sdl_device_subsystem;

import kelp_core.core;
import kelp_core.device;
import kelp_sdl.device;
import bindbc.sdl;
import kelp_core.logger;

class SDLDeviceSubsystem : Subsystem
{
	SDLKeyboard keyboard;
	SDLMouse mouse;
	SDLGamepad gamepad;

	this(Core core)
	{
		super(core);
		scope DeviceSubsystem device_subsystem;
		device_subsystem = core.subsystem.query!DeviceSubsystem();
		this.keyboard = new SDLKeyboard(device_subsystem);
		this.mouse = new SDLMouse(device_subsystem);
		this.gamepad = new SDLGamepad(device_subsystem);
		return;
	}

	typeof(this) initialize()
	{

		this.keyboard.initialize();
		this.mouse.initialize();
		this.gamepad.initialize();
		return this;
	}

	typeof(this) finalize()
	{
		this.keyboard.finalize();
		this.mouse.finalize();
		this.gamepad.finalize();
		return this;
	}

	typeof(this) process()
	{
		this.keyboard.process();
		this.mouse.process();
		this.gamepad.process();
		return this;
	}
}
