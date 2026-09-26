extends Node

const ORTHOGONAL_DIRECTIONS: Array[Vector3i] = [
	Vector3i.RIGHT,
	Vector3i.LEFT,
	Vector3i.BACK,
	Vector3i.FORWARD,
]

func is_in_orthogonal_range(from: Vector3i, to: Vector3i, max_range: int) -> bool:
	var dx = abs(to.x - from.x)
	var dz = abs(to.z - from.z)
	
	var distance = dx + dz
	if distance == 0 or distance > max_range:
		return false
	
	return (dx == 0 and dz > 0) or (dz == 0 and dx > 0)

func is_in_rhombus_range(from: Vector3i, to: Vector3i, max_range: int, min_range: int = 1) -> bool:
	var dx = abs(to.x - from.x)
	var dz = abs(to.z - from.z)
	
	var distance = dx + dz
	return distance <= max_range and distance >= min_range

func get_all_adjacent_cells(cell: Vector3i) -> Array[Vector3i]:
	var neighbors_array: Array[Vector3i]
	
	for dir in ORTHOGONAL_DIRECTIONS:
		var neighbor = cell + dir
		neighbors_array.append(neighbor)
	
	return neighbors_array

func get_adjacent_cells(cell: Vector3i) -> Array[Vector3i]:
	var neighbors_array: Array[Vector3i]
	
	for dir in ORTHOGONAL_DIRECTIONS:
		var neighbor = cell + dir
		
		if GridPathfinder.instance.is_tile_walkable(neighbor):
			neighbors_array.append(neighbor)
	
	return neighbors_array

func get_closest_adjacent(start: Vector3i, target: Vector3i) -> Vector3i:
	var all_available: Array[Vector3i] = get_adjacent_cells(target)
	if all_available.is_empty(): return Vector3i.MIN
	
	var closest_cell: Vector3i
	var shortest_path: int = 99
	
	for cell in all_available:
		var path = GridPathfinder.instance.get_grid_path(start, cell)
		if shortest_path > path.size():
			closest_cell = cell
	
	return closest_cell
