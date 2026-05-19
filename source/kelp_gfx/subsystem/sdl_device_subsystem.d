module kelp_gfx.subsystem.sdl_device_subsystem;

import kelp_core.core;
import kelp_core.device;
import kelp_sdl.device;
import bindbc.sdl;

class SDLDeviceSubsystem : Subsystem
{
	DeviceSubsystem device;
	SDLKeyboard keyboard;
	SDLMouse mouse;
	SDLGamepad gamepad;

	this(Core core)
	{
		super(core);
		this.keyboard = new SDLKeyboard();
		this.mouse = new SDLMouse();
		this.gamepad = new SDLGamepad();
		return;
	}

	typeof(this) initialize()
	{
		this.device = core.subsystem.pool.query!(DeviceSubsystem);
		this.keyboard.device_subsystem = this.device;
		this.mouse.device = this.device;
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
