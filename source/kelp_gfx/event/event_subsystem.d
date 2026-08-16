module kelp_gfx.event.event_subsystem;

import kelp_core.core;
import kelp_core.input;
import kelp_sdl.input;
import bindbc.sdl;

import std.array : Appender, array;
import std.algorithm : map;

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
		input.pool.append(
			poll_sdl_event().convert()
		);
		return this;
	}
}

SDL_Event[] poll_sdl_event()
{
	scope Appender!(SDL_Event[]) event_list;
	scope SDL_Event event;

	while (SDL_PollEvent(&event))
	{
		event_list ~= event;
	}
	return event_list[];
}
