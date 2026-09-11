class_name Spawner
extends Node

@export var grid: GridMap

@export var spawn_list: Array[SpawnData]

func _ready() -> void:
	spawn_all_units()

func spawn_all_units() -> void:
	for data in spawn_list:
		spawn_unit(data)

func spawn_unit(data: SpawnData) -> Node3D:
	var instance = data.scene.instantiate() as Node3D
	if not instance.has_method("setup_position"): return null
	
	instance.add_to_group(data.group)
	
	get_tree().root.add_child.call_deferred(instance)
	await instance.tree_entered
	
	instance.call("setup_position", data.spawn_tile_cell, grid)
	return instance
