module kelp_gfx.input.converter.text;

import kelp_core.input.event.text;
import bindbc.sdl : SDL_TextEditingEvent, SDL_TextEditingCandidatesEvent, SDL_TextInputEvent;
import std.string : fromStringz;
import std.algorithm : map;
import std.array : array;


TextEditingEvent text_editing_event(SDL_TextEditingEvent event) pure nothrow @trusted
{
	return TextEditingEvent(
		event.text.fromStringz().idup
	);
}

TextEditCandidateEvent text_edit_candidate_event(in SDL_TextEditingCandidatesEvent event) pure nothrow @trusted
{
	scope const(char*)[] candidates = event.candidates[0 .. cast(size_t) event.num_candidates];
	return TextEditCandidateEvent(
		candidates.map!(str => str.fromStringz().idup).array()
	);
}

TextInputEvent text_input_event(in SDL_TextInputEvent event) pure nothrow @trusted
{
	return TextInputEvent(event.text.fromStringz().idup);
}
