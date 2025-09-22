module kelp_render.graphics.graphics;

/+
version (Windows)
{
	import core.sys.windows.dll;

	mixin SimpleDllMain;
}
+/

import kelp_api;
//import kelp_core;
import bindbc.sdl;

//export extern(C):

class Graphics : Subsystem
{
// delete after
import std.exception;
import std.string;

	SDL_GPUDevice* device_ref;
	SDL_Window* window_ref;

	this()
	{
		return;
	}

	void initialize()
	{
		import std.stdio;
		writeln("initialize");
		device_ref = SDL_CreateGPUDevice(
			SDL_GPU_SHADERFORMAT_SPIRV | SDL_GPU_SHADERFORMAT_DXIL | SDL_GPU_SHADERFORMAT_MSL,
			true,
			null
		);
		enforce(device_ref !is null);
		window_ref = SDL_CreateWindow(toStringz("SDL Graphics"), 960, 540, SDL_WINDOW_RESIZABLE);
		enforce(window_ref !is null);
		if (!SDL_ClaimWindowForGPUDevice(device_ref, window_ref))
		{
			assert(false);
		}
		return;
	}

	void finalize()
	{
		SDL_ReleaseWindowFromGPUDevice(device_ref, window_ref);
		SDL_DestroyWindow(window_ref);
		SDL_DestroyGPUDevice(device_ref);
		return;
	}

	void process()
	{
		SDL_GPUCommandBuffer* command_buffer = SDL_AcquireGPUCommandBuffer(device_ref);
		enforce(command_buffer !is null);
		SDL_GPUTexture* swapchain_texture_ref;
		bool result;
		result = SDL_WaitAndAcquireGPUSwapchainTexture(
			command_buffer,
			window_ref,
			&swapchain_texture_ref,
			null, null,
		);
		enforce(result == true);

		if (swapchain_texture_ref !is null)
		{
			SDL_GPUColorTargetInfo color_target_info = SDL_GPUColorTargetInfo.init;
			color_target_info.texture = swapchain_texture_ref;
			color_target_info.clear_color = SDL_FColor(0.3f, 0.4f, 0.5f, 1.0f);
			color_target_info.load_op = SDL_GPU_LOADOP_CLEAR;
			color_target_info.store_op = SDL_GPU_STOREOP_STORE;

			SDL_GPURenderPass* render_pass = SDL_BeginGPURenderPass(
				command_buffer,
				&color_target_info,
				1,
				null
			);
			SDL_EndGPURenderPass(render_pass);
		}

		SDL_SubmitGPUCommandBuffer(command_buffer);
		return;
	}

}

export Subsystem createSubsystem()
{
	return cast(Subsystem) new Graphics();
}
