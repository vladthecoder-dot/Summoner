class_name Spawner
extends Node

static var instance: Spawner
@export var spawn_list: Array[SpawnData]

signal unit_spawned(unit: GridCharacter)
signal initial_spawn_complete()

func _ready() -> void:
	spawn_all_units()
	instance = self

func spawn_all_units() -> void:
	for data in spawn_list:
		spawn_unit(data)
	
	initial_spawn_complete.emit()
	print("Everything spawned")

func spawn_unit(data: SpawnData) -> GridCharacter:
	var unit = data.scene.instantiate() as GridCharacter
	if not unit.has_method("setup_position"): return null
	
	get_tree().root.add_child.call_deferred(unit)
	await unit.tree_entered
	
	unit.setup_position(data.spawn_tile_cell)
	unit_spawned.emit(unit)
	return unit
