module kelp_gfx.input.gamepad;

import kelp_sdl.input.gamepad;
import bindbc.sdl;

class GamepadManager
{
	Gamepad gamepad;

	typeof(this) initialize()
	{
		this.try_open();
		return this;
	}

	typeof(this) finalize()
	{
		return this;
	}

	typeof(this) process()
	{
		this.gamepad.update();
		return this;
	}

	typeof(this) try_open()
	{
		if (this.gamepad.opened)
		{
			return this;
		}
		scope SDL_JoystickID[] list = get_gamepad_list();
		if (list.length >= 1)
		{
			this.gamepad.open(list[0]);
		}
		return this;
	}
}
