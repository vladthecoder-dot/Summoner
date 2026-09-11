@abstract
class_name BaseAction
extends Resource

@export var name: String
@export var description: String

@abstract func activate(context: Dictionary)
@abstract func deactivate()
