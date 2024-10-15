extends State
class_name EnemyDeath

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter():
	print("Entering enemy death state")
	animation_player.play("death")

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass
