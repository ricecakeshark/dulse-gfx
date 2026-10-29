module dulse_gfx.text.text_context;

import dulse.core;
import dulse.graphics;
import dulse.math;
import dulse_sdl.graphics;
import dulse_sdl.text;
import dulse_sdl.video.surface;
import sdl.gpu;
import sdl_ttf;

import std.array : array, Appender, RefAppender;
import std.algorithm : map, uniq;

class GfxTextContext
{
	TextFont text_font;
	GpuTextEngine text_engine;
	GpuText text;

	protected GpuDevice device;

	this(GpuDevice device)
	{
		text_font = new TextFont();
		text_engine = new GpuTextEngine(device);
		text = new GpuText(text_engine, text_font);
		this.device = device;
		return;
	}

	typeof(this) load_font(in string font_file, in float font_size)
	{
		text_font.create(font_file, font_size);
		return this;
	}

	typeof(this) create_engine()
	{
		text_engine.create();
		return this;
	}

	typeof(this) create_text(in string str)
	{
		text.create(str);
		return this;
	}

	typeof(this) release()
	{
		this.text.release();
		this.text_engine.release();
		this.text_font.release();
		return this;
	}

	typeof(this) get_draw_data(G : GfxGeometry!(V, I), V, I)(
		ref GfxMesh mesh,
		out GpuRefTexture[] texture_list
	)
	{
		scope TTF_GPUAtlasDrawSequence* sequence_ptr;

		scope Appender!(G[]) temp_geometry_list;
		scope Appender!(V[]) temp_vertex_list;
		scope Appender!(I[]) temp_index_list;
		scope Appender!(SDL_GPUTexture*[]) temp_texture_ptr_list;
		temp_geometry_list.clear();
		sequence_ptr = this.text.get_draw_data();
		assert(sequence_ptr !is null);
		for (TTF_GPUAtlasDrawSequence* seq = sequence_ptr; seq !is null; seq = seq.next)
		{
			assert(seq.atlas_texture !is null);
			assert(seq.num_vertices > 0);
			assert(seq.num_indices > 0);
			temp_vertex_list.clear();
			temp_index_list.clear();

			foreach (count; 0 .. seq.numVertices)
			{
				temp_vertex_list ~= V(
					Vec3(seq.xy[count].x, seq.xy[count].y, 0.0f,),
					Vec2(seq.uv[count].x, seq.uv[count].y,),
				);
			}
			foreach (count; 0 .. seq.numIndices)
			{
				temp_index_list ~= I(seq.indices[count]);
			}
			temp_geometry_list ~= G(
				temp_vertex_list[].dup, temp_index_list[].dup,
			);
			temp_texture_ptr_list ~= seq.atlas_texture;
		}
		mesh.set(temp_geometry_list[]);
		texture_list = temp_texture_ptr_list[]
			.map!(ptr => (new GpuRefTexture(this.device)).refer(ptr))
			.array();
		return this;
	}

	typeof(this) process_draw_data(
		void delegate(TTF_GPUAtlasDrawSequence*) sequence_dlg,
	)
	{
		TTF_GPUAtlasDrawSequence* sequence_ptr;
		sequence_ptr = this.text.get_draw_data();
		assert(sequence_ptr !is null);
		assert(sequence_ptr.atlas_texture !is null);
		assert(sequence_ptr.num_indices >= 0);
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
	// font align
	@property TextAlign wrap_align()
	{
		return this.text_font.wrap_align;
	}

	typeof(this) set(in TextAlign wrap_align)
	{
		this.text_font.set(wrap_align);
		return this;
	}
	// font direction
	@property TextDirection direction()
	{
		return this.text_font.direction;
	}

	typeof(this) set(TextDirection font_direction)
	{
		this.text_font.set(font_direction);
		return this;
	}
	// font hinting
	@property FontHinting hinting()
	{
		return this.text_font.hinting();
	}

	typeof(this) set(in FontHinting font_hinting)
	{
		this.text_font.set(font_hinting);
		return this;
	}
	// font size
	@property float font_size()
	{
		return this.text_font.size();
	}

	typeof(this) set_font_size(float font_size)
	{
		this.text_font.set_size(font_size);
		return this;
	}
	// font string size
	typeof(this) get_string_size(in string text, out int w, out int h)
	{
		text_font.get_string_size(text, w, h);
		return this;
	}
	// font SDF
	@property bool SDF()
	{
		return this.text_font.SDF;
	}

	typeof(this) set_SDF(bool mode_SDF = true)
	{
		this.text_font.set_SDF(mode_SDF);
		return this;
	}
	// font style
	@property FontStyle style()
	{
		return this.text_font.style();
	}

	typeof(this) set(in FontStyle font_style)
	{
		this.text_font.set(font_style);
		return this;
	}
	// engine winding
	typeof(this) set(in TextEngineWinding winding)
	{
		this.text_engine.set(winding);
		return this;
	}
	// text color
	typeof(this) get(out ColorF color)
	{
		text.get(color);
		return this;
	}

	typeof(this) set(in ColorF color)
	{
		text.set(color);
		return this;
	}
	// text position
	typeof(this) set(in int[2] pos)
	{
		text.set_pos(pos);
		return this;
	}
	// text size
	typeof(this) get_text_size(out int w, out int h)
	{
		text.get_size(w, h);
		return this;
	}
	// text string
	typeof(this) set(in string str)
	{
		text.set_string(str);
		return this;
	}

}

class TextSurfaceContext
{
	TextFont text_font;
	SurfaceTextEngine text_engine;
	SurfaceText text;

	this(GpuDevice device)
	{
		text_font = new TextFont();
		text_engine = new SurfaceTextEngine(device);
		text = new SurfaceText(text_engine, text_font);
		return;
	}

	typeof(this) load_font(in string font_file, in float font_size)
	{
		text_font.create(font_file, font_size);
		return this;
	}

	typeof(this) create_engine()
	{
		text_engine.create();
		return this;
	}

	typeof(this) create_text(in string str)
	{
		text.create(str);
		return this;
	}

	typeof(this) draw(
		ref Surface surface,
		in int x = 0,
		in int y = 0,
	)
	{
		this.text.draw(surface, x, y);
		return this;
	}

	typeof(this) set(in string str)
	{
		text.set_string(str);
		return this;
	}

	typeof(this) get_size(out int w, out int h)
	{
		text.get_size(w, h);
		return this;
	}
}
