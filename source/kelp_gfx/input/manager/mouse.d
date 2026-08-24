module kelp_gfx.input.manager.mouse;

import kelp_core.input;
import kelp_core.core.container.ring_buffer;
import kelp_core.math.linalg.vector;
import kelp_sdl.input.mouse;

class MouseManager
{
	Mouse mouse;

	invariant
	{
		assert(this !is null);
	}

	void initialize()
	{
		mouse.initalize();
		return;
	}

	void finalize()
	{
		return;
	}

	typeof(this) process()
	{
		this.mouse.process();
		return this;
	}

	typeof(this) update()
	{
		this.mouse.update();
		return this;
	}

	typeof(this) apply(in Event[] event_list)
	{
		this.mouse.apply(event_list);
		return this;
	}

	alias mouse this;
}

struct Mouse
{
	RingBuffer!(MouseState, 5) state_list;

	ref typeof(this) initalize()
	{
		this.state_list.fill();
		return this;
	}

	void process()
	{
		this.state_list.append(this.state_list[$ - 1]);
		return;
	}

	typeof(this) update()
	{
		apply_mouse_state(this.state_list.tail);
		return this;
	}

	void apply(in Event[] event_list...) pure nothrow
	{
		this.state_list.tail.apply(event_list);
		return;
	}

	bool moved()
	{
		if (this.state_list.tail.rel_pos != Vec2(0f, 0f))
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	bool pressed(MouseButton button_type)
	{
		return this.state_list.tail.button[button_type].pressed;
	}

	bool pressed_just(MouseButton button_type)
	{
		return this.state_list.tail.button[button_type].pressed_just;
	}

	bool released(MouseButton button_type)
	{
		return !this.state_list.tail.button[button_type].pressed;
	}

	bool released_just(MouseButton button_type)
	{
		return this.state_list.tail.button[button_type].released_just;
	}
}
