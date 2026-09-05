module dulse_gfx.input.manager.text;

import dulse.input.event.event;
import dulse.input.state.text;
import dulse_sdl.input.text;
import dulse_sdl.video.window;

final class TextManager
{
	InputTextState state;
	Window window;

	this()
	{
		return;
	}

	invariant
	{
		assert(this !is null);
	}

	typeof(this) initialize()
	{
		//this.start();
		return this;
	}

	typeof(this) finalize()
	{
		return this;
	}

	typeof(this) process()
	{
		return this;
	}

	typeof(this) update()
	{
		return this;
	}

	typeof(this) apply(in Event[] event_list...)
	{
		this.state.apply(event_list);
		return this;
	}

	typeof(this) start()
	{
		start_text_input(this.window);
		return this;
	}

	typeof(this) stop()
	{
		stop_text_input(this.window);
		return this;
	}
}
