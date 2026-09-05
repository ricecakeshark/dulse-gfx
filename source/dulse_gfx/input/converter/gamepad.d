module dulse_gfx.input.converter.gamepad;

import dulse.input.device.gamepad;
import dulse.input.event.gamepad;
import dulse.math.linalg.vector;
import sdl.events : SDL_GamepadAxisEvent, SDL_GamepadButtonEvent;

GamepadButtonEvent gamepad_button_event(in SDL_GamepadButtonEvent gbutton) pure nothrow @nogc @trusted
{
	return GamepadButtonEvent(
		gamepad_button(gbutton.button),
		gbutton.down,
	);
}

GamepadAxisEvent gamepad_axis_event(in SDL_GamepadAxisEvent gaxis) pure nothrow @nogc @trusted
{
	return GamepadAxisEvent(
		gamepad_axis(gaxis.axis),
		gamepad_axis_value(gaxis.value),
	);
}

GamepadButton gamepad_button(in ubyte button) pure nothrow @nogc @safe
{
	return cast(GamepadButton) button;
}

GamepadAxis gamepad_axis(in ubyte axis) pure nothrow @nogc @safe
{
	return cast(GamepadAxis) axis;
}

Vec1 gamepad_axis_value(in short value) pure nothrow @nogc @safe
{
	return Vec1(1.0 / value);
}
