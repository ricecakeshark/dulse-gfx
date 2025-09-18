module graphics.graphics;

version(Windows)
{
	import core.sys.windows.dll;
	mixin SimpleDllMain;
}

import kelp_api, kelp_core;
import bindbc.sdl;

export class Graphics
{
	this()
	{

	}

	void initialize()
	{
		return;
	}

	void finalize()
	{
		return;
	}

	void process()
	{
		return;
	}
}