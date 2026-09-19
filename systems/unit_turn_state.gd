class_name TurnParticipant
extends RefCounted

var character: GridCharacter
var stats: StatsComponent

var current_energy: int = 0
var character_energy: int:
	get: return stats.maximum_energy
var character_energy_regen: int:
	get: return stats.energy_regeneration

const ACTION_NUMERATOR: float = 100.0
var current_action_value: float
var character_speed: int:
	get: return stats.speed
var base_action_value: float:
	get: return ACTION_NUMERATOR / character_speed

var action_history: Array[BaseAction]

func _init(tracked_character: GridCharacter) -> void:
	character = tracked_character
	stats = character.get_component(StatsComponent)
	current_energy = character_energy
	reset_action_value()

func reset_action_value() -> void:
	current_action_value = base_action_value
