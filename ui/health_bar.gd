class_name HealthBar
extends ProgressBar

var camera: Camera3D
var target_character: GridCharacter:
	get: return health_component.owning_character
@export var health_component: HealthComponent

@export_category("Visual")
@export var offset: Vector3 = Vector3(0, 2.2, 0)
@export var health_time: float = 0.2

func _ready() -> void:
	hide()
	camera = get_viewport().get_camera_3d()
	setup()

func setup() -> void:
	health_component.current_health_changed.connect(current_health_change)
	
	max_value = health_component.max_health
	value = health_component.current_health
	
	show()

func _process(_delta: float) -> void:
	var world_pos = target_character.global_position + offset
	
	var screen_pos = camera.unproject_position(world_pos)
	global_position = screen_pos - (size / 2)

func current_health_change() -> void:
	var tween = create_tween()
	tween.tween_property(self, "value", health_component.current_health, health_time)
	tween.set_trans(Tween.TRANS_SINE)
