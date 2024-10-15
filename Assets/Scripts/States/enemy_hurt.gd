extends State
class_name EnemyHurt

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
#@onready var run: EnemyRun = $"../run"

func enter():
	#enemy = get_tree().get_first_node_in_group("Enemy")
	print("Entering enemy hurt state")
	animation_player.play("hurt")

func exit():
	pass

func update(_delta: float):
	#Adding this in the scenario if player attacks enemy away from raycast detection
	#if !animation_player.is_playing() && run.from_run:
		#Transition.emit(self, "run")
	
	#Also add checks for if player is nearby!! To go to alert/run state
	if !animation_player.is_playing():
		Transition.emit(self, "idle")

func physics_update(_delta: float):
	pass
