class_name GridCharacter
extends CharacterBody3D

var current_path: Array[Vector3] = []
var current_cell: Vector3i:
	set(value):
		if pathfinder == null: return
		pathfinder.set_tile_blocked(current_cell, false)
		current_cell = value
		pathfinder.set_tile_blocked(current_cell, true)
var pathfinder: GridPathfinder

@export var move_speed: float = 5
@export var rotation_speed: float = 12
@export var look_at_duration: float = 0.15
var facing_direction: Vector3

var is_selected: bool = false
var outline_resource: StandardMaterial3D = preload("uid://3tfjw6y8ivgd")

func setup_position(cell: Vector3i, map: GridPathfinder) -> void:
	pathfinder = map
	current_cell = cell
	global_position = map.map_to_local(cell)
	print("cell:%v global position to map:%v" % [current_cell, map.local_to_map(global_position)])

func start_movement(target_position: Vector3) -> bool:
	if not current_path.is_empty(): return false
	var packed_path = pathfinder.get_path_to_world_pos(global_position, target_position)
	current_path.append_array(packed_path)
	return true if packed_path.size() > 0 else false

func _physics_process(delta: float) -> void:
	if current_path.is_empty(): return
	
	var target_pos = current_path[0]
	global_position = global_position.move_toward(target_pos, move_speed * delta)
	
	var move_dir = (target_pos - global_position)
	move_dir.y = 0
	if move_dir.length_squared() > 0.001:
		facing_direction = move_dir.normalized()
		rotate_towards(facing_direction, delta)
	
	if global_position.distance_to(target_pos) < 0.005:
		current_cell = pathfinder.local_to_map(current_path[0])
		current_path.remove_at(0)

func rotate_towards(direction: Vector3, delta: float) -> void:
	var target_basis = Transform3D.IDENTITY.looking_at(direction, Vector3.UP).basis
	global_basis = global_basis.slerp(target_basis, rotation_speed * delta)

func look_at_target(target_world: Vector3) -> void:
	var dir = target_world - global_position
	dir.y = 0
	
	if dir.length_squared() > 0.001:
		facing_direction = dir.normalized()
		var target_basis = Transform3D.IDENTITY.looking_at(facing_direction, Vector3.UP).basis
		var tween = create_tween()
		tween.tween_property(self, "global_transform:basis", target_basis, look_at_duration)

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
