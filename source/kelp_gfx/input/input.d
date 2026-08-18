module kelp_gfx.input.input;

import kelp_core.input;
import kelp_core.math.linalg.vector;
import bindbc.sdl;
import std.array : Appender;
import core.time : MonoTime;
import std.sumtype;

Event[] convert(
	SDL_Event[] in_event_list,
)
{
	scope Appender!(Event[]) out_event_list;

	foreach (in_event; in_event_list)
	{
		out_event_list ~= convert(in_event);
	}
	return out_event_list[];
}

Event convert(SDL_Event in_event)
{
	switch (event_type_major(cast(SDL_EventType) in_event.type))
	{
	case EventTypeMajor.quit:
		return event(
			in_event.quit.timestamp,
			QuitEvent(),
		);
		assert(0);
		/+case EventTypeMajor.window:
		switch (event_type_minor(cast(SDL_EventType) in_event.type))
		{
		case EventTypeMinor.window_minimized:
			return event(
				in_event.window.timestamp,
				WindowMinimizedEvent(),
			);
		default:
			assert(false);
		}+/

	case EventTypeMajor.keyboard:

		return event(
			in_event.key.timestamp,
			KeyboardKeyEvent(
				cast(MonoTime) in_event.key.timestamp,
				cast(Scancode) in_event.key.scancode,
				in_event.key.down,
				in_event.key.repeat,
		),
		);
	case EventTypeMajor.mouse:

		switch (event_type_minor(cast(SDL_EventType) in_event.type))
		{
		case EventTypeMinor.mouse_motion:
			return event(
				in_event.motion.timestamp,
				MouseMotionEvent(
					Vec2(in_event.motion.x, in_event.motion.y),
					Vec2(in_event.motion.xrel, in_event.motion.yrel),
			),
			);
		case EventTypeMinor.mouse_button:
			return event(
				in_event.button.timestamp,
				MouseButtonEvent(
					mouse_button_type(in_event.button.button),
					in_event.button.down,
			),
			);
		case EventTypeMinor.mouse_wheel:
			return event(
				in_event.wheel.timestamp,
				MouseWheelEvent(Vec2(in_event.wheel.x, in_event.wheel.y)),
			);
		default:
			assert(false);
		}
		/+case EventTypeMajor.gamepad:
		return Event(
			in_event.gamepad.timestamp,
			GamepadButtonEvent(),
		);+/
	default:
		return Event(MonoTime.currTime);
	}
}

/+
Event convert(SDL_Event in_event)
{
	switch (in_event.type)
	{
	case SDL_EventType.quit:
		return event(EventTypeMinor.quit);
	case SDL_EventType.keyboard:
		return event(EventTypeMinor.keyboard);
	case SDL_EventType.mouse:
		return event(EventTypeMinor.mouse);
	default:
		return event(EventTypeMinor.invalid);
	}
}+/

EventTypeMajor event_type_major(
	SDL_EventType type,
)
{
	switch (type)
	{
	case SDL_EventType.quit:
		return EventTypeMajor.quit;
	case SDL_EventType.windowMinimized:
	case SDL_EventType.windowMaximized:
		return EventTypeMajor.window;
	case SDL_EventType.keyDown:
		return EventTypeMajor.keyboard;
	case SDL_EventType.keyUp:
		return EventTypeMajor.keyboard;
	case SDL_EventType.mouseMotion:
	case SDL_EventType.mouseWheel:
	case SDL_EventType.mouseButtonDown:
	case SDL_EventType.mouseButtonUp:
		return EventTypeMajor.mouse;
	case SDL_EventType.gamepadButtonDown:
	case SDL_EventType.gamepadButtonUp:
		return EventTypeMajor.gamepad;
	default:
		return EventTypeMajor.other;
	}
}

EventTypeMinor event_type_minor(
	SDL_EventType event_type,
)
{
	switch (event_type)
	{
	case SDL_EventType.quit:
		return EventTypeMinor.quit;
	case SDL_EventType.windowMinimized:
		return EventTypeMinor.window_minimized;
	case SDL_EventType.windowMaximized:
		return EventTypeMinor.window_maximized;
	case SDL_EventType.keyDown, SDL_EventType.keyUp:
		return EventTypeMinor.keyboard_key;
	case SDL_EventType.mouseMotion:
		return EventTypeMinor.mouse_motion;
	case SDL_EventType.mouseWheel:
		return EventTypeMinor.mouse_wheel;
	case SDL_EventType.mouseButtonDown,
		SDL_EventType.mouseButtonUp:
		return EventTypeMinor.mouse_button;
	case SDL_EventType.gamepadButtonDown,
		SDL_EventType.gamepadButtonUp:
		return EventTypeMinor.gamepad_button;
	case SDL_EventType.gamepadAxisMotion:
		return EventTypeMinor.gamepad_axis;
	default:
		return EventTypeMinor.other;
	}
}

/+EventType event_data(
	SDL_Event event,
)
{
	switch (event_type(event.type))
	{
	case EventTypeMinor.quit:
		return Event(event.quit.timestamp, QuitEvent());
	case EventTypeMinor.window:
		return EventTypeMinor.window;
	case EventTypeMinor.keyboard:
		return EventTypeMinor.keyboard;
	case EventTypeMinor.mouseMotion, SDL_EventType:
		return EventTypeMinor.mouse;
	case EventTypeMinor.gamepad:
		return EventTypeMinor.gamepad;
	default:
		return EventTypeMinor.other;
	}
}
+/

MouseButtonType mouse_button_type(ubyte flags) pure nothrow @nogc @safe
{
	final switch (flags)
	{
	case 1u << MouseButtonType.left:
		return MouseButtonType.left;
	case 1u << MouseButtonType.middle:
		return MouseButtonType.middle;
	case 1u << MouseButtonType.right:
		return MouseButtonType.right;
	case 1u << MouseButtonType.x1:
		return MouseButtonType.x1;
	case 1u << MouseButtonType.x2:
		return MouseButtonType.x2;
	}
}

Event[] poll_sdl_event()
{
	scope Appender!(Event[]) event_list;
	scope SDL_Event event;

	while (SDL_PollEvent(&event))
	{
		event_list ~= event.convert();
	}
	return event_list[];
}
