module kelp_render.text_context;

import kelp_core.core;
import kelp_sdl.graphics;
import bindbc.sdl;

class GPUTextContext
{
	GPUTextFont text_font;
	GPUTextEngine text_engine;
	GPUText text;

	this(GPUDevice device)
	{
		text_font = new GPUTextFont();
		text_engine = new GPUTextEngine(device);
		text = new GPUText(text_engine, text_font);
		return;
	}

	typeof(this) load_font(string font_file, float font_size)
	{
		text_font.create(font_file, font_size);
		return this;
	}

	typeof(this) create_engine()
	{
		text_engine.create();
		return this;
	}

	typeof(this) create_text(string str)
	{
		text.create(str);
		return this;
	}

	typeof(this) get_draw_data(out float[][] vertex_data, out int[] index_data)
	{
		TTF_GPUAtlasDrawSequence* sequence_ptr;
		sequence_ptr = text.get_draw_data();
		assert(sequence_ptr !is null);
		for (TTF_GPUAtlasDrawSequence* seq = sequence_ptr; seq !is null; seq = seq.next)
		{
			assert(seq.num_vertices > 0);
			assert(seq.num_indices > 0);
			assert(seq.atlas_texture !is null);
			foreach (count; 0 .. seq.numVertices)
			{
				vertex_data ~= [
					seq.xy[count].x,
					seq.xy[count].y,
					0.0f,
					0.1f, 0.5f, 0.9f, 1.0f,
					seq.uv[count].x,
					seq.uv[count].y,
				];
			}
			index_data ~= seq.indices[0 .. seq.numIndices];
		}
		return this;
	}

	typeof(this) process_draw_data(
		void delegate(TTF_GPUAtlasDrawSequence*) sequence_dlg,
	)
	{
		TTF_GPUAtlasDrawSequence* sequence_ptr;
		sequence_ptr = text.get_draw_data();
		assert(sequence_ptr !is null);
		for (TTF_GPUAtlasDrawSequence* seq = sequence_ptr; seq !is null; seq = seq.next)
		{
			sequence_dlg(seq);
		}
		return this;
	}

	typeof(this) get_sequence_ptr(out TTF_GPUAtlasDrawSequence* sequence_ptr)
	{
		sequence_ptr = text.get_draw_data();
		return this;
	}

	typeof(this) set(string str)
	{
		text.set_string(str);
		return this;
	}

	typeof(this) get_size(out int w, out int h)
	{
		text.get_size(w, h);
		return this;
	}

	typeof(this) set(ColorF color)
	{
		text.set_color(color);
		return this;
	}

	typeof(this) set_align()
	{
		text_font.set_align();
		return this;
	}
}
