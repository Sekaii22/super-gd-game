extends Label

@onready var attack_grace_timer: Timer = $"../AttackGraceTimer"

func _process(delta: float) -> void:
	text = str(attack_grace_timer.time_left)
