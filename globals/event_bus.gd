@warning_ignore_start("unused_signal")
extends Node

const DEBUG_PERFIX = "EVENT_BUS: "

func _ready() -> void:
	pass
	#action_executed.connect(action_debug_print)

func action_debug_print(action, executor) -> void:
	print(DEBUG_PERFIX, "%s executed by %s" % [action.name, executor.name])

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
signal action_executed(action: BaseAction, executor: GridCharacter)
signal action_canceled

# Health events
signal trying_to_damage_character(target: GridCharacter, damage: int)
signal trying_to_heal_character(target: GridCharacter, health: int)
