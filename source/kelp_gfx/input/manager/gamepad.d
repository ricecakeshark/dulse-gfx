module kelp_gfx.input.manager.gamepad;

import kelp_core.core.container.ring_buffer;
import kelp_core.input.event.event;
import kelp_core.input.device.gamepad;
import kelp_core.input.state.gamepad;
import kelp_core.math.linalg.vector;
import kelp_sdl.input.gamepad;
import bindbc.sdl;

class GamepadManager
{
	Gamepad[4] gamepad_list;

	Gamepad opIndex(size_t index) pure @nogc @safe
	{
		assert(index < 4);
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

	typeof(this) update()
	{
		this.gamepad_list[0].update();
		return this;
	}

	typeof(this) apply(in Event[] event_list...) pure nothrow
	{
		this.gamepad_list[0].apply(event_list);
		return this;
	}
}
