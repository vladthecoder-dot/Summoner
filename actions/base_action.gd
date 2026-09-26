@abstract
class_name BaseAction
extends Resource

@export var name: String = "ACTION_NAME"
@export var description: String = "ACTION_DESCRIPTION"
@export var cost: int = 0

func can_be_activated() -> bool:
	return true
@abstract func activate(context: Dictionary) -> void
@abstract func deactivate() -> void
