extends State
class_name PlayerFall2

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter():
	player = get_tree().get_first_node_in_group("Player")
	
	# TODO: Change the fall animation
	# Placeholder animation
	print("Entering player fall 2 state")
	animation_player.play("jump")
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	var direction := Input.get_axis("move-left", "move-right")
	player.velocity.x = direction * player.SPEED + player.knockback.x
	
	if player.is_on_floor():
		# Reset jumps
		player.jumps_left = player.no_of_jumps
		
		if direction == 0:
			Transition.emit(self, "idle")
		else:
			Transition.emit(self, "run")
			
	if Input.is_action_just_pressed("attack"):
		Transition.emit(self, "attack")


func _on_player_damage_taken() -> void:
	Transition.emit(self, "hurt")


func _on_player_death() -> void:
	Transition.emit(self, "death")
