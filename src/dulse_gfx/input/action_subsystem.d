module dulse_gfx.input.action_subsystem;

import dulse.core;
import dulse.input;
import dulse.math.linalg : Vec1, Vec2;
import dulse_gfx.input;

class ActionSubsystem : Subsystem!ActionSubsystem
{
	protected InputSubsystem input;
	TypeTable!(ActionState!Vec1, ActionState!Vec2) state_table;
	TypeTable!(ActionBinding!Vec1, ActionBinding!Vec2) binding_table;
	alias state = state_table;
	alias binding = binding_table;

	this(Core core)
	{
		super(core);
		return;
	}

	override typeof(this) initialize()
	{
		core.subsystem.query(input);
		this.state_table.clear();
		this.binding_table.clear();
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
			input.gamepad[0].state_list.head,
		);

		foreach (binding; binding_table.query!(ActionBinding!Vec1))
		{
			binding.handle(input_state, state_table);
		}
		foreach (binding; binding_table.query!(ActionBinding!Vec2))
		{
			binding.handle(input_state, state_table);
		}

		return this;
	}
}
