class_name RaycastSelect
extends Node

enum Mode { SELECTING, TARGETING }

@export var camera: Camera3D
#@export var pathfinder: GridPathfinder
@export var raycast_length: float = 1000

var current_mode: Mode = Mode.SELECTING
var controllable_character: GridCharacter

func _ready() -> void:
	EventBus.switched_to_targeting.connect(func(): current_mode = Mode.TARGETING)
	EventBus.swithced_to_selecting.connect(func(): current_mode = Mode.SELECTING)

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
	EventBus.player_click.emit(target_world_pos)
	var target_body: Node3D = result["collider"]
	match current_mode:
		Mode.SELECTING: selector(target_body)
		Mode.TARGETING:
			if target_body is GridCharacter:
				EventBus.character_targeted.emit(target_body)
			else:
				EventBus.cell_targeted.emit()

func selector(target_body: Node3D) -> void:
	if target_body is not GridCharacter: return
	
	if controllable_character != null:
		deselect_current()
		select_controllable(target_body)
	else:
		select_controllable(target_body)

func select_controllable(body: GridCharacter) -> void:
	controllable_character = body
	controllable_character.set_selected(true)
	EventBus.character_selected.emit(controllable_character)

func deselect_current() -> void:
	if controllable_character == null: return
	controllable_character.set_selected(false)
	controllable_character = null
	EventBus.character_deselected.emit()
