module dulse_gfx.input.manager.keyboard;

import dulse.input;
import dulse.core.container.ring_buffer;
import dulse_sdl.input.keyboard;
import core.time : MonoTime;

final class KeyboardManager
{
	Keyboard keyboard;

	invariant
	{
		assert(this !is null);
	}

	void initialize()
	{
		this.keyboard.initialize();
		return;
	}

	void finalize()
	{
		return;
	}

	void process()
	{
		this.keyboard.process();
		return;
	}

	void apply(in Event[] event_list...) pure nothrow
	{
		this.keyboard.apply(event_list);
		return;
	}

	alias keyboard this;
	/+bool pressed(Scancode scancode)
	{
		return this.state_list[$ - 1].pressed(scancode);
	}

	bool released(Scancode scancode)
	{
		return this.state_list[$ - 1].pressed(scancode);
	}

	bool pressed_just(Scancode scancode)
	{
		return (this.state_list[$ - 1].pressed(scancode) && !this.state_list[$ - 2].pressed(
				scancode));
	}

	bool released_just(Scancode scancode)
	{
		return (!this.state_list[$ - 1].pressed(scancode) && this.state_list[$ - 2].pressed(
				scancode));
	}+/
}

struct Keyboard
{
	RingBuffer!(KeyboardState, 5) state_list;

	ref typeof(this) initialize() return pure nothrow @nogc @safe
	{
		this.state_list.fill();
		return this;
	}

	ref typeof(this) process() return nothrow @safe
	{
		this.state_list.append(this.state_list.tail);
		this.state_list.tail.catch_up();
		return this;
	}

	ref typeof(this) apply(in Event[] event_list) return pure nothrow @safe
	{
		this.state_list.tail.apply(event_list);
		return this;
	}

	bool pressed(in Scancode scancode) pure nothrow @nogc @safe
	{
		return this.state_list.tail.pressed(scancode);
	}

	bool released(in Scancode scancode) pure nothrow @nogc @safe
	{
		return this.state_list.tail.pressed(scancode);
	}

	bool pressed_just(in Scancode scancode) pure nothrow @nogc @safe
	{
		return this.state_list.tail.key_list[scancode].pressed_just == true;
	}

	bool released_just(in Scancode scancode) pure nothrow @nogc @safe
	{
		return this.state_list.tail.key_list[scancode].released_just == true;
	}
}
