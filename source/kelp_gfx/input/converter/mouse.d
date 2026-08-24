module kelp_gfx.input.converter.mouse;

import kelp_core.input.device.mouse;
import kelp_core.input.event.mouse;
import kelp_core.math.linalg.vector;
import sdl.events : SDL_MouseMotionEvent, SDL_MouseButtonEvent, SDL_MouseWheelEvent;


MouseMotionEvent mouse_motion_event(in SDL_MouseMotionEvent motion) pure nothrow @nogc @trusted
{
	return MouseMotionEvent(
		Vec2(motion.x, motion.y),
		Vec2(motion.xrel, motion.yrel),
	);
}

MouseButtonEvent mouse_button_event(in SDL_MouseButtonEvent button) pure nothrow @nogc @trusted
{
	return MouseButtonEvent(
		mouse_button_type(button.button),
		button.down,
	);
}

MouseWheelEvent mouse_wheel_event(in SDL_MouseWheelEvent wheel) pure nothrow @nogc @trusted
{
	return MouseWheelEvent(
		Vec2(wheel.x, wheel.y)
	);
}

MouseButton mouse_button_type(ubyte flags) pure nothrow @nogc @safe
{
	final switch (flags)
	{
	case 1u << MouseButton.left:
		return MouseButton.left;
	case 1u << MouseButton.middle:
		return MouseButton.middle;
	case 1u << MouseButton.right:
		return MouseButton.right;
	case 1u << MouseButton.x1:
		return MouseButton.x1;
	case 1u << MouseButton.x2:
		return MouseButton.x2;
	}
}
