class_name SimpleMeleeEnemy
extends EnemyStrategy

func _ready() -> void:
	TurnManager.instance.turn_started.connect(func(character):
		if character == owning_character:
			take_turn())

func take_turn() -> void:
	target_character = get_closest_target()
	print("Target: ", target_character.name)
	var adjacent_cells = GridCalculations.get_all_adjacent_cells(target_cell)
	if not adjacent_cells.has(owner_cell):
		var best_cell = GridCalculations.get_closest_adjacent(owner_cell, target_cell)
		actions_component.execute_action_with("Move", {"ai_position": best_cell})
		await owning_character.movement_stopped
	actions_component.execute_action("End turn")
