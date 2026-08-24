module kelp_gfx.input.converter.event;

import kelp_core.input.event;
import kelp_gfx.input.converter;
import sdl.events;
import std.array : appender, Appender, RefAppender;

Event[] convert(
	in SDL_Event[] in_event_list,
) pure nothrow
{
	scope Appender!(Event[]) out_event_list;

	foreach (in_event; in_event_list)
	{
		out_event_list ~= convert(in_event);
	}
	return out_event_list[];
}

Event convert(in SDL_Event in_event) pure nothrow @trusted
{
	switch (event_type(cast(SDL_EventType) in_event.type).major)
	{
	case EventTypeMajor.quit:
		return event(
			in_event.quit.timestamp,
			QuitEvent(),
		);
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
			keyboard_key_event(in_event.key),
		);
	case EventTypeMajor.text:
		switch (event_type(cast(SDL_EventType) in_event.type).minor)
		{
		case EventTypeMinor.text_editing:
			return event(
				in_event.edit.timestamp,
				text_editing_event(in_event.edit),
			);
		case EventTypeMinor.text_candidate:
			return event(in_event.edit_candidates.timestamp,
				text_edit_candidate_event(in_event.edit_candidates)
			);
		case EventTypeMinor.text_input:
			return event(in_event.text.timestamp, text_input_event(in_event.text));
		default:
			assert(false, "not supported text event");
		}

	case EventTypeMajor.mouse:

		switch (event_type(cast(SDL_EventType) in_event.type).minor)
		{
		case EventTypeMinor.mouse_motion:
			return event(
				in_event.motion.timestamp,
				mouse_motion_event(in_event.motion),
			);
		case EventTypeMinor.mouse_button:
			return event(
				in_event.button.timestamp,
				mouse_button_event(in_event.button),
			);
		case EventTypeMinor.mouse_wheel:
			return event(
				in_event.wheel.timestamp,
				mouse_wheel_event(in_event.wheel),
			);
		default:
			assert(false, "invalid event_type_minor in mouse");
		}
	case EventTypeMajor.gamepad:
		switch (event_type(cast(SDL_EventType) in_event.type).minor)
		{
		case EventTypeMinor.gamepad_button:
			return event(
				in_event.motion.timestamp,
				gamepad_button_event(in_event.gbutton),

			);
		case EventTypeMinor.gamepad_axis:
			return event(
				in_event.button.timestamp,
				gamepad_axis_event(in_event.gaxis),
			);
		default:
			assert(false, "invalid event_type_minor in gamepad");
		}
	default:
		return Event();
	}
}

EventType event_type(
	in SDL_EventType event_type,
) pure nothrow @nogc @safe
{
	switch (event_type)
	{
	case SDL_EventType.quit:
		return EventType(EventTypeMajor.quit, EventTypeMinor.quit);
	case SDL_EventType.windowMinimized:
		return EventType(EventTypeMajor.window, EventTypeMinor.window_minimized);
	case SDL_EventType.windowMaximized:
		return EventType(EventTypeMajor.window, EventTypeMinor.window_maximized);
	case SDL_EventType.keyDown, SDL_EventType.keyUp:
		return EventType(EventTypeMajor.keyboard, EventTypeMinor.keyboard_key);
	case SDL_EventType.textEditing:
		return EventType(EventTypeMajor.text, EventTypeMinor.text_editing);
	case SDL_EventType.textInput:
		return EventType(EventTypeMajor.text, EventTypeMinor.text_input);
	case SDL_EventType.textEditingCandidates:
		return EventType(EventTypeMajor.text, EventTypeMinor.text_candidate);
	case SDL_EventType.mouseMotion:
		return EventType(EventTypeMajor.mouse, EventTypeMinor.mouse_motion);
	case SDL_EventType.mouseWheel:
		return EventType(EventTypeMajor.mouse, EventTypeMinor.mouse_wheel);
	case SDL_EventType.mouseButtonDown,
		SDL_EventType.mouseButtonUp:
		return EventType(EventTypeMajor.mouse, EventTypeMinor.mouse_button);
	case SDL_EventType.gamepadButtonDown:
	case SDL_EventType.gamepadButtonUp:
		return EventType(EventTypeMajor.gamepad, EventTypeMinor.gamepad_button);
	case SDL_EventType.gamepadAxisMotion:
		return EventType(EventTypeMajor.gamepad, EventTypeMinor.gamepad_axis);
	default:
		return EventType(EventTypeMajor.other, EventTypeMinor.other);
	}
}
