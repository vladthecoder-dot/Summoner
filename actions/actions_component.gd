class_name ActionsComponent
extends Node

@export var owning_character: GridCharacter

@export var available_actions: Array[BaseAction]
@export var internal_context: Dictionary

var current_action: BaseAction

func _ready() -> void:
	internal_context["character"] = owning_character
	internal_context["stats"] = owning_character.get_component(StatsComponent)
	
	EventBus.action_executed.connect(func(action, executor): 
		if current_action == action and owning_character == executor:
			current_action = null)

func execute_action_with(action_name: String, external_context: Dictionary) -> void:
	var results = available_actions.filter(func(res): return res and res.name == action_name)
	var matched_action = results[0] as BaseAction if not results.is_empty() else null
	
	if matched_action == null or not matched_action.can_be_activated(): 
		return
	elif current_action != null:
		current_action.deactivate()
	
	external_context.merge(internal_context)
	
	matched_action.activate(external_context)
	current_action = matched_action

func execute_action(action_name: String) -> void:
	execute_action_with(action_name, {})

func get_action(action_class: GDScript) -> BaseAction:
	for action in available_actions:
		if is_instance_of(action, action_class):
			return action
	
	return null
