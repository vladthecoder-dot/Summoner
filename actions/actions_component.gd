class_name ActionsComponent
extends Node

@export var owning_character: GridCharacter

@export var available_actions: Array[BaseAction]
@export var context: Dictionary

var current_action: BaseAction

func _ready() -> void:
	context["character"] = owning_character
	
	EventBus.action_executed.connect(func(_action): current_action = null)

func execute_action(action_name: String) -> void:
	var results = available_actions.filter(func(res): return res and res.name == action_name)
	var matched_action = results[0] as BaseAction if not results.is_empty() else null
	
	if matched_action == null: 
		return
	elif current_action != null:
		current_action.deactivate()
	
	matched_action.activate(context)
	current_action = matched_action
