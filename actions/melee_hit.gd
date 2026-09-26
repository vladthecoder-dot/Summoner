class_name MeleeHit
extends BaseAction

var character: GridCharacter
@export_range(0, 99, 1, "or_greater") var damage: int = 4
@export_range(1, 9, 1, "or_greater") var max_range: int = 1

func can_be_activated() -> bool:
	return not TurnManager.instance.is_action_used(MeleeHit)

func activate(context: Dictionary) -> void:
	if not can_be_activated():
		return
	
	character = context.get("character")
	if character == null: return
	
	EventBus.switched_to_targeting.emit()
	EventBus.action_canceled.connect(deactivate)
	EventBus.character_targeted.connect(attack)

func attack(target: GridCharacter) -> void:
	var character_cell = character.current_cell
	var target_cell = target.current_cell
	if GridCalculations.is_in_orthogonal_range(character_cell, target_cell, max_range):
		EventBus.trying_to_damage_character.emit(target, damage)
		deactivate()
		EventBus.action_executed.emit(self, character)

func deactivate() -> void:
	EventBus.action_canceled.disconnect(deactivate)
	EventBus.character_targeted.disconnect(attack)
	EventBus.swithced_to_selecting.emit()
