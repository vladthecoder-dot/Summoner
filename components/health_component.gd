class_name HealthComponent
extends Node

var owning_character: GridCharacter
var alive: bool = true
@export_range(1, 99, 1, "or_greater") var max_health: int = 10
var current_health: int:
	set(value):
		if value > max_health:
			current_health = max_health
		elif value <= 0:
			current_health = 0
			alive = false
		else:
			current_health = value
		current_health_changed.emit()

signal current_health_changed()

func _ready() -> void:
	current_health = max_health
	owning_character = get_parent()
	if owning_character is not GridCharacter:
		return
	
	EventBus.trying_to_damage_character.connect(func(character, amount):
		if character == owning_character:
			take_damage(amount))
	
	EventBus.trying_to_heal_character.connect(func(character, amount):
		if character == owning_character:
			heal(amount))

func revive(health_amount: int = 1) -> void:
	alive = true
	heal(health_amount)

func take_damage(amount: int) -> void:
	if amount <= 0 or not alive:
		return
	
	current_health -= amount

func heal(amount: int) -> void:
	if amount <= 0 or not alive:
		return
	
	current_health += amount
