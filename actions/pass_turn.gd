class_name PassTurn
extends BaseAction

func activate(context: Dictionary) -> void:
	TurnManager.instance.pass_turn()

func deactivate() -> void:
	pass
