module kelp_gfx.input.converter.keyboard;

import kelp_core.input.device.keyboard;
import kelp_core.input.event : KeyboardKeyEvent;
import sdl.events : SDL_KeyboardEvent;
import core.time : MonoTime;

KeyboardKeyEvent keyboard_key_event(SDL_KeyboardEvent key_event) pure nothrow @nogc @trusted
{
	return KeyboardKeyEvent(
		cast(MonoTime) key_event.timestamp,
		cast(Scancode) key_event.scancode,
		key_event.down,
		key_event.repeat,
	);
}
