class_name MoveAction
extends BaseAction

var character: GridCharacter

func activate(context: Dictionary) -> void:
	character = context.get("character")
	if character == null: return
	
	EventBus.player_click.connect(move)
	EventBus.action_canceled.connect(deactivate)

func move(position_world: Vector3) -> void:
	var result = character.start_movement(position_world)
	if result == true:
		deactivate()
		EventBus.action_executed.emit(self)

func deactivate() -> void:
	EventBus.action_canceled.disconnect(deactivate)
	EventBus.player_click.disconnect(move)
