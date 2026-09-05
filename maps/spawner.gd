extends Node
class_name Spawner

@export var scene: PackedScene
@export var grid: GridMap
@export var spawn_tile_cell: Vector3i

func _ready() -> void:
	spawn_player()

func spawn_player() -> Node3D:
	var instance = scene.instantiate() as Node3D
	if not instance.has_method("setup_position"): return null
	
	instance.add_to_group("player_unit")
	
	get_tree().root.add_child.call_deferred(instance)
	await instance.tree_entered
	
	instance.call("setup_position", spawn_tile_cell, grid)
	return instance
