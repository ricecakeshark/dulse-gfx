module dulse_gfx.input.manager.gamepad;

import dulse.core.container.ring_buffer;
import dulse.input.event.event;
import dulse.input.device.gamepad;
import dulse.input.state.gamepad;
import dulse.math.linalg.vector;
import dulse_sdl.input.gamepad;
import sdl.joystick, sdl.gamepad;

class GamepadManager
{
	Gamepad[4] gamepad_list;

	Gamepad opIndex(in size_t index) pure nothrow @nogc @safe
	in (index < gamepad_list.length)
	{
		return this.gamepad_list[index];
	}

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
		this.gamepad_list[0].process();
		return this;
	}

	typeof(this) try_open()
	{
		if (this.gamepad_list[0].opened)
		{
			return this;
		}
		scope SDL_JoystickID[] list = get_gamepad_list();
		if (list.length >= 1)
		{
			this.gamepad_list[0].open(list[0]);
		}
		return this;
	}

	typeof(this) apply(in Event[] event_list...) pure nothrow
	{
		this.gamepad_list[0].apply(event_list);
		return this;
	}
}
