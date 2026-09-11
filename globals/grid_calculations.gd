extends Node

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
