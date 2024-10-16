extends State
class_name EnemyHurt

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var enemy: CharacterBody2D = $"../.."


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
		if enemy.from_run == true:
			Transition.emit(self, "run")
		else:
			Transition.emit(self, "idle")

func physics_update(_delta: float):
	pass




func _on_enemy_death() -> void:
	Transition.emit(self, "death")
