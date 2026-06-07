module kelp_gfx.event.event_subsystem;

import kelp_core.core;
import kelp_core.input;
import bindbc.sdl;

import std.array, std.algorithm;

class GfxEventSubsystem : Subsystem
{
	InputSubsystem input;

	this(Core core)
	{
		super(core);
		return;
	}

	typeof(this) initialize()
	{
		input = this.core.subsystem.query!(InputSubsystem);
		return this;
	}

	typeof(this) finalize()
	{
		return this;
	}

	typeof(this) process()
	{
		input.pool.append(poll_event());
		return this;
	}
}

Event[] poll_event()
{
	return poll_sdl_event()
		.map!(event => event.normalize())
		.array();
}

Event normalize(in SDL_Event event) pure nothrow @nogc @safe
{
	switch (event.type)
	{
	case SDL_EVENT_QUIT:
		return Event(EventType.quit);
	default:
		return Event(EventType.none);
	}
}

SDL_Event[] poll_sdl_event()
{
	import std.array : Appender;

	Appender!(SDL_Event[]) event_list;
	SDL_Event event;

	while (SDL_PollEvent(&event))
	{
		event_list.put(event);
	}
	return event_list[];
}
