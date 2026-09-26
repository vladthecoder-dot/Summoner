@abstract
class_name EnemyStrategy
extends Node

@export var owning_character: GridCharacter
@onready var actions_component: ActionsComponent = owning_character.get_component(ActionsComponent)
@onready var pass_turn_action: PassTurn = actions_component.get_action(PassTurn)
@onready var move_action: MoveAction = actions_component.get_action(MoveAction)

var owner_cell: Vector3i:
	get: return owning_character.current_cell

var target_character: GridCharacter
var target_cell: Vector3i:
	get:
		if target_character != null:
			return target_character.current_cell
		else:
			return Vector3i.MIN

@abstract func take_turn() -> void

func get_closest_target(group: String = "player_unit") -> GridCharacter:
	var shortest_distance = 99
	var target: GridCharacter
	for unit in TurnManager.instance.units_on_field:
		var potential_target = unit.character
		if not potential_target.is_in_group(group) or potential_target == owning_character:
			continue
		
		var potential_cell = potential_target.current_cell
		var close_cell = GridCalculations.get_closest_adjacent(owner_cell, potential_cell)
		
		var path = GridPathfinder.instance.get_grid_path(owner_cell, close_cell)
		var distance_to_target = path.size()
		
		print("Pot: %s, distance: %d" % [potential_target.name, distance_to_target])
		
		if shortest_distance >= distance_to_target:
			shortest_distance = distance_to_target
			target = potential_target
	
	return target
