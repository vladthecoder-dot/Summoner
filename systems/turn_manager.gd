class_name TurnManager
extends Node

const DEBUG_PREFIX = "TURN_MANAGER: "

static var instance: TurnManager

signal turn_started(unit: GridCharacter)
signal turn_ended()

var units_on_field: Array[TurnParticipant]
var active_unit: TurnParticipant

static var current_character: GridCharacter:
	get: return instance.active_unit.character

func _ready() -> void:
	Spawner.instance.unit_spawned.connect(init_unit)
	EventBus.action_executed.connect(func(action, executor): 
		if active_unit != null and current_character == executor:
			active_unit.action_history.append(action))
	
	instance = self
	await get_tree().process_frame
	start_battle()

func init_unit(unit: GridCharacter) -> void:
	var new_turn_state = TurnParticipant.new(unit)
	units_on_field.append(new_turn_state)

func start_battle() -> void:
	print(DEBUG_PREFIX, "Battle started!")
	pass_turn()

func pass_turn() -> void:
	if active_unit != null:
		active_unit.reset_action_value()
		active_unit.character.set_active(false)
		turn_ended.emit()
	
	active_unit = get_next_unit()
	var unit_av = active_unit.current_action_value
	
	for unit in units_on_field:
		if unit == active_unit: continue
		unit.current_action_value -= unit_av
		print(DEBUG_PREFIX, "%s action value updated: %d" % [unit.character, unit.current_action_value])
	
	active_unit.action_history.clear()
	
	active_unit.character.set_active(true)
	
	print()
	print(DEBUG_PREFIX, "its %s turn" % active_unit.character.name)
	turn_started.emit(active_unit.character)

func get_next_unit() -> TurnParticipant:
	var fastest_unit: TurnParticipant = null
	for unit in units_on_field:
		if fastest_unit == null:
			fastest_unit = unit
			continue
		
		var fastest_av = fastest_unit.current_action_value
		var current_av = unit.current_action_value
		
		# or fastest_av == current_av and unit.character.is_in_group("player_unit")
		if fastest_av > current_av:
			fastest_unit = unit
	
	return fastest_unit

func is_action_used(action_class: Script) -> bool:
	for action in active_unit.action_history:
		if is_instance_of(action, action_class):
			return true
	return false
