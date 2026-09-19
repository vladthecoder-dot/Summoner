@abstract
class_name BaseAction
extends Resource

@export var name: String = "ACTION_NAME"
@export var description: String = "ACTION_DESCRIPTION"
@export var cost: int = 0

@abstract func activate(context: Dictionary)
@abstract func deactivate()
