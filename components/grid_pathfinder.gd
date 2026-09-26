class_name GridPathfinder
extends GridMap

static var instance: GridPathfinder

var astar: AStar3D = AStar3D.new()
var cell_ids: Dictionary[Vector3i, int]

func _ready() -> void:
	setup_grid_pathfinding()
	instance = self

func setup_grid_pathfinding() -> void:
	var grid_cells = get_used_cells()
	for cell in grid_cells:
		var point_id = astar.get_available_point_id()
		var cell_position = map_to_local(cell)
		astar.add_point(point_id, cell_position)
		cell_ids[cell] = point_id
	
	for cell in grid_cells:
		var current_id = cell_ids[cell]
		for dir in GridCalculations.ORTHOGONAL_DIRECTIONS:
			var neighbor_cell = cell + dir
			if not cell_ids.has(neighbor_cell):
				continue
			
			var neighbor_id = cell_ids[neighbor_cell]
			if astar.are_points_connected(current_id, neighbor_id): 
				continue
			
			astar.connect_points(current_id, neighbor_id)

func get_grid_path(start_cell: Vector3i, end_cell: Vector3i) -> PackedVector3Array:
	if not cell_ids.has(start_cell) or not cell_ids.has(end_cell):
		return []
	
	var start_id = cell_ids[start_cell]
	var end_id = cell_ids[end_cell]
	
	var is_start_disabled = astar.is_point_disabled(start_id)
	astar.set_point_disabled(start_id, false)
	
	var path = astar.get_point_path(start_id, end_id)
	
	astar.set_point_disabled(start_id, is_start_disabled)
	
	return path

func get_path_to_world_pos(start_world: Vector3, end_world: Vector3) -> PackedVector3Array:
	var start_cell = local_to_map(start_world)
	var end_cell = local_to_map(end_world)
	
	var path = get_grid_path(start_cell, end_cell)
	
	return path

func set_tile_blocked(cell: Vector3i, blocked: bool):
	if not cell_ids.has(cell): return
	var point_id = cell_ids[cell]
	astar.set_point_disabled(point_id, blocked)

func is_tile_walkable(cell: Vector3i) -> bool:
	if not cell_ids.has(cell):
		return false
	
	var cell_id = cell_ids[cell]
	var is_walkable = not astar.is_point_disabled(cell_id)
	return is_walkable
