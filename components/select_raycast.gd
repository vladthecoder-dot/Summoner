extends Node
class_name RaycastSelect

@export var camera: Camera3D
@export var pathfinder: GridPathfinder
@export var raycast_length: float = 1000

var controllable_character: MovableCharacter

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		mouse_select()

func mouse_select() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * raycast_length
	
	var space_state = camera.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	
	var result = space_state.intersect_ray(query)
	if not result: 
		print("no result")
		return
	
	var target_world_pos = result.position
	var target_body: Node3D = result["collider"]
	if controllable_character != null:
		if target_body.is_in_group("player_unit"):
			deselect_current()
			select_controllable(target_body)
		else:
			controllable_character.start_movement(target_world_pos)
			deselect_current()
	else:
		select_controllable(target_body)

func select_controllable(body: Node3D) -> void:
	if body.is_in_group("player_unit"):
		controllable_character = body
		controllable_character.set_selected(true)

func deselect_current() -> void:
	if controllable_character == null: return
	
	controllable_character.set_selected(false)
	controllable_character = null
