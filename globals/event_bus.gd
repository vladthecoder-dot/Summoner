@warning_ignore_start("unused_signal")
extends Node

func _ready() -> void:
	character_deselected.connect(func(): action_canceled.emit())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		action_canceled.emit()

# Mouse events
signal player_click(position: Vector3)

signal character_selected(character: GridCharacter)
signal character_deselected

signal character_targeted(character: GridCharacter)
signal cell_targeted(cell_world: Vector3)

signal switched_to_targeting
signal swithced_to_selecting

# Actions events
signal action_selected(action: BaseAction)
signal action_executed()
signal action_canceled()

signal actions_component_selected(component: ActionsComponent)

# Health events
signal trying_to_damage_character(target: GridCharacter, damage: int)
signal trying_to_heal_character(target: GridCharacter, health: int)
