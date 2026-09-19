extends Control

@onready var options_container: VBoxContainer = $OptionsContainer
var selected_character: GridCharacter

func _ready() -> void:
	await get_tree().process_frame
	TurnManager.instance.turn_started.connect(show_actions)
	TurnManager.instance.turn_ended.connect(hide_actions)

func show_actions(character: GridCharacter) -> void:
	if not character.is_in_group("player_unit"): return
	
	var action_component = character.get_component(ActionsComponent)
	if action_component == null: return
	
	for action in action_component.available_actions:
		var button = Button.new()
		var exec = action_component.execute_action.bind(action.name)
		button.text = action.name
		button.pressed.connect(exec)
		options_container.add_child(button)

func hide_actions() -> void:
	for option in options_container.get_children():
		option.queue_free()
