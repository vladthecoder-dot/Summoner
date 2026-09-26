class_name MoveAction
extends BaseAction

var character: GridCharacter

func activate(context: Dictionary) -> void:
	print("MOVE_ACTION: ", context)
	character = context.get("character")
	if character == null: return
	
	if character.is_in_group("player_unit"):
		EventBus.player_click.connect(player_move)
		EventBus.action_canceled.connect(deactivate)
	elif character.is_in_group("enemy_unit"):
		var position = context.get("ai_position")
		if position != null:
			move(position)

func move(cell: Vector3i) -> void:
	var result = character.start_movement(cell)
	if result == true:
		deactivate()
		EventBus.action_executed.emit(self, character)

func player_move(position_world: Vector3) -> void:
	var cell = GridPathfinder.instance.local_to_map(position_world)
	move(cell)

func deactivate() -> void:
	if character != null and character.is_in_group("player_unit"):
		EventBus.action_canceled.disconnect(deactivate)
		EventBus.player_click.disconnect(player_move)
	
	character = null
