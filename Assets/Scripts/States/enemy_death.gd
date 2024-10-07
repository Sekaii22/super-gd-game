extends State
class_name EnemyDeath

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var enemy: Node2D = $"../.."

func enter():
	#enemy = get_tree().get_first_node_in_group("Enemy")
	print("Entering enemy death state")
	animation_player.play("death")

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass
