module kelp_gfx.input.converter.text;

import kelp_core.input.event.text;
import bindbc.sdl : SDL_TextEditingEvent, SDL_TextEditingCandidatesEvent, SDL_TextInputEvent;
import std.string : fromStringz;
import std.algorithm : map;
import std.array : array;

public:
TextEditingEvent convert(SDL_TextEditingEvent event) pure nothrow
{
	return TextEditingEvent(event.text.fromStringz().idup);
}

TextEditCandidateEvent convert(in SDL_TextEditingCandidatesEvent event)
{
	const(char*)[] candidates = event.candidates[0 .. cast(size_t) event.num_candidates];
	return TextEditCandidateEvent(
		candidates.map!(str => str.fromStringz().idup).array()
	);
}

TextInputEvent convert(in SDL_TextInputEvent event)
{
	return TextInputEvent(event.text.fromStringz().idup);
}
