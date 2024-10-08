extends State
class_name EnemyHurt

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var enemy: Node2D = $"../.."

func enter():
	#enemy = get_tree().get_first_node_in_group("Enemy")
	print("Entering enemy hurt state")
	animation_player.play("hurt")

func exit():
	pass

func update(_delta: float):
	
	#Also add checks for if player is nearby!! To go to alert/run state
	if !animation_player.is_playing():
		Transition.emit(self, "idle")

func physics_update(_delta: float):
	pass
