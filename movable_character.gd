extends CharacterBody3D
class_name MovableCharacter

var current_path: Array[Vector3] = []
var current_cell: Vector3i:
	set(value):
		if pathfinder == null: return
		pathfinder.set_tile_blocked(current_cell, false)
		current_cell = value
		pathfinder.set_tile_blocked(current_cell, true)
var pathfinder: GridPathfinder

@export var move_speed: float = 5

var is_selected: bool = false
var outline_resource: StandardMaterial3D = preload("uid://3tfjw6y8ivgd")

func setup_position(cell: Vector3i, map: GridPathfinder) -> void:
	pathfinder = map
	current_cell = cell
	global_position = map.map_to_local(cell)
	print("cell:%v global position to map:%v" % [current_cell, map.local_to_map(global_position)])

func start_movement(target_position: Vector3):
	if not current_path.is_empty(): return
	var packed_path = pathfinder.get_path_to_world_pos(global_position, target_position)
	current_path.append_array(packed_path)

func _physics_process(delta: float) -> void:
	if current_path.is_empty(): return
	
	var target_pos = current_path[0]
	global_position = global_position.move_toward(target_pos, move_speed * delta)
	
	if global_position.distance_to(target_pos) < 0.005:
		current_cell = pathfinder.local_to_map(current_path[0])
		current_path.remove_at(0)

func set_selected(selected: bool) -> void:
	is_selected = selected
	apply_outline(self, selected)

func apply_outline(node: Node, enable: bool) -> void:
	for child in node.get_children():
		apply_outline(child, enable)
	
	if node is not MeshInstance3D: return
	
	if enable:
		node.material_overlay = outline_resource
	else:
		node.material_overlay = null
