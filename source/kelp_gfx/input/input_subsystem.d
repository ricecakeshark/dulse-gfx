module kelp_gfx.input.input_subsystem;

import kelp_core.core.core;
import kelp_core.core.subsystem;
import kelp_core.core.message_bus;
import kelp_core.input;
import kelp_core.math.linalg.vector;
import kelp_sdl.input;
import kelp_gfx.input.manager;
import TextConv = kelp_gfx.input.converter.text;
import bindbc.sdl;
import std.array : appender, Appender, RefAppender;
import core.time : MonoTime;
import std.string : fromStringz;
import std.algorithm : map;
import std.array : array;

class GfxInputSubsystem : Subsystem
{
	public KeyboardManager keyboard;
	public MouseManager mouse;
	public GamepadManager gamepad;

	this(Core core)
	{
		super(core);
		this.keyboard = new KeyboardManager();
		this.mouse = new MouseManager();
		this.gamepad = new GamepadManager();
		return;
	}

	~this()
	{
		return;
	}

	typeof(this) initialize()
	{
		this.keyboard.initialize();
		this.mouse.initialize();
		this.gamepad.initialize();
		return this;
	}

	typeof(this) finalize()
	{
		this.keyboard.finalize();
		this.mouse.finalize();
		this.gamepad.finalize();
		return this;
	}

	typeof(this) process()
	{
		scope Event[] event_pool;
		poll_event(event_pool);
		foreach (event; event_pool)
		{
			if (event.type.major == EventTypeMajor.quit)
			{
				this.core.bus.send(new QuitMessage());
			}
		}
		this.keyboard.process();
		this.keyboard.update();
		this.keyboard.apply(event_pool);
		this.mouse.process();
		this.mouse.update();
		this.mouse.apply(event_pool);
		this.gamepad.process();
		this.gamepad.update();
		this.gamepad.apply(event_pool);

		return this;
	}
}

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
			KeyboardKeyEvent(
				cast(MonoTime) in_event.key.timestamp,
				cast(Scancode) in_event.key.scancode,
				in_event.key.down,
				in_event.key.repeat,
		),
		);
	case EventTypeMajor.text:
		switch (event_type(cast(SDL_EventType) in_event.type).minor)
		{
		case EventTypeMinor.text_editing:
			return event(
				in_event.edit.timestamp,
				TextConv.convert(in_event.edit)
			);
		case EventTypeMinor.text_candidate:
			return event(in_event.edit_candidates.timestamp, TextConv.convert(
					in_event.edit_candidates));
		case EventTypeMinor.text_input:
			return event(in_event.text.timestamp, TextConv.convert(in_event.text));
		default:
			assert(false, "not supported text event");
		}

	case EventTypeMajor.mouse:

		switch (event_type(cast(SDL_EventType) in_event.type).minor)
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
			assert(false, "invalid event_type_minor in mouse");
		}
	case EventTypeMajor.gamepad:
		switch (event_type(cast(SDL_EventType) in_event.type).minor)
		{
		case EventTypeMinor.gamepad_button:
			return event(
				in_event.motion.timestamp,
				GamepadButtonEvent(
					gamepad_button(in_event.gbutton.button),
					in_event.gbutton.down,
			),
			);
		case EventTypeMinor.gamepad_axis:
			return event(
				in_event.button.timestamp,
				GamepadAxisEvent(
					gamepad_axis(in_event.gaxis.axis),
					gamepad_axis_value(in_event.gaxis.value),
			),
			);
		default:
			assert(false, "invalid event_type_minor in gamepad");
		}
	default:
		return Event(MonoTime.currTime);
	}
}

EventType event_type(
	SDL_EventType event_type,
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

GamepadButton gamepad_button(ubyte button) pure nothrow @nogc @safe
{
	return cast(GamepadButton) button;
}

GamepadAxis gamepad_axis(ubyte axis) pure nothrow @nogc @safe
{
	return cast(GamepadAxis) axis;
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

void poll_event(out Event[] out_event_list)
{
	scope RefAppender!(Event[]) event_list;
	scope SDL_Event event;
	event_list = appender(&out_event_list);
	while (SDL_PollEvent(&event))
	{
		event_list ~= event.convert();
	}
	return;
}
