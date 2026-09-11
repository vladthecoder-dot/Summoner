class_name ActionsComponent
extends Node

@export var available_actions: Array[BaseAction]
@export var context: Dictionary

var current_action: BaseAction

func _ready() -> void:
	var parent = get_parent()
	if parent is not GridCharacter: 
		return
	
	context["character"] = get_parent() as GridCharacter
	EventBus.character_selected.connect(func(character): 
		if character == parent:
			EventBus.actions_component_selected.emit(self))
	
	EventBus.action_executed.connect(func(): current_action = null)

func execute_action(action_name: String) -> void:
	var results = available_actions.filter(func(res): return res and res.name == action_name)
	var matched_action = results[0] as BaseAction if not results.is_empty() else null
	
	if matched_action == null: 
		return
	elif current_action != null:
		current_action.deactivate()
	
	matched_action.activate(context)
	current_action = matched_action
