module dulse_gfx.input.action_subsystem;

import dulse.core;
import dulse.input;
import dulse.math.linalg : Vec1, Vec2;
import dulse_gfx.input;

class ActionSubsystem : Subsystem!ActionSubsystem
{
	protected InputSubsystem input;
	TypeTable!(ActionState!Vec1, ActionState!Vec2) state_table;
	MonoPool!ActionBinding binding_pool;
	alias state = state_table;
	alias binding = binding_pool;

	this(Core core)
	{
		super(core);
		return;
	}

	override typeof(this) initialize()
	{
		core.subsystem.query(input);
		this.state_table.clear();
		this.binding_pool.clear();
		return this;
	}

	override typeof(this) finalize()
	{
		return this;
	}

	override typeof(this) process()
	{
		scope InputState input_state;

		input_state = InputState(
			input.keyboard.keyboard.state_list.head,
			input.mouse.mouse.state_list.head,
			GamepadState.init,
		);

		foreach (binding; binding_pool.all)
		{
			binding.handle(input_state, state_table);
		}

		return this;
	}
}
