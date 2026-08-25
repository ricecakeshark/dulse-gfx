module kelp_gfx.input.input_subsystem;

import kelp_core.core.core;
import kelp_core.core.subsystem;
import kelp_core.core.message_bus;
import kelp_core.input.event;
import kelp_gfx.input;
import sdl.events;
import std.array : appender, Appender, RefAppender;
import core.time : MonoTime;

class GfxInputSubsystem : Subsystem
{
	public KeyboardManager keyboard;
	public MouseManager mouse;
	public GamepadManager gamepad;
	public TextManager text;

	this(Core core)
	{
		super(core);
		this.keyboard = new KeyboardManager();
		this.mouse = new MouseManager();
		this.gamepad = new GamepadManager();
		this.text = new TextManager();
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
		this.text.initialize();
		return this;
	}

	typeof(this) finalize()
	{
		this.keyboard.finalize();
		this.mouse.finalize();
		this.gamepad.finalize();
		this.text.finalize();
		return this;
	}

	typeof(this) process()
	{
		scope Event[] event_pool;
		event_pool = poll_sdl_event();
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
		this.text.process();
		this.text.update();
		this.text.apply(event_pool);
		return this;
	}
}

Event[] poll_sdl_event() nothrow @trusted
{
	scope Appender!(Event[]) event_list;
	scope SDL_Event event;

	while (SDL_PollEvent(&event))
	{
		event_list ~= event.convert();
	}
	return event_list[];
}

void poll_event(out Event[] out_event_list) nothrow @trusted
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
