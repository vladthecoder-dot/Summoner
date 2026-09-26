extends Control

@onready var options_container: VBoxContainer = $OptionsContainer

func _ready() -> void:
	await get_tree().process_frame
	TurnManager.instance.turn_started.connect(show_actions.unbind(1))
	TurnManager.instance.turn_ended.connect(hide_actions)
	EventBus.action_executed.connect(reload_buttons.unbind(2))

func show_actions() -> void:
	var character = TurnManager.current_character
	if not character.is_in_group("player_unit"): return
	
	var action_component := character.get_component(ActionsComponent) as ActionsComponent
	if action_component == null: return
	
	for action in action_component.available_actions:
		var button = Button.new()
		var exec = action_component.execute_action.bind(action.name)
		
		button.text = action.name
		button.disabled = not action.can_be_activated()
		
		button.pressed.connect(exec)
		
		options_container.add_child(button)

func hide_actions() -> void:
	for option in options_container.get_children():
		option.queue_free()

func reload_buttons() -> void:
	hide_actions()
	show_actions()
