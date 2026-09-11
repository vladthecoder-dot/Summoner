extends Control

@onready var options_container: VBoxContainer = $OptionsContainer
var selected_character: GridCharacter

func _ready() -> void:
	EventBus.actions_component_selected.connect(show_actions)
	EventBus.character_deselected.connect(hide_actions)

func show_actions(action_component: ActionsComponent) -> void:
	for action in action_component.available_actions:
		var button = Button.new()
		var exec = action_component.execute_action.bind(action.name)
		button.text = action.name
		button.pressed.connect(exec)
		options_container.add_child(button)

func hide_actions() -> void:
	for option in options_container.get_children():
		option.queue_free()
