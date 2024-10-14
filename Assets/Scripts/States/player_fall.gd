extends State
class_name PlayerFall

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter():
	player = get_tree().get_first_node_in_group("Player")
	
	# Fall animation
	print("Entering player fall state")
	animation_player.play("fall")
	
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
		
		# TODO: Transit to landing state
		
		if direction == 0:
			Transition.emit(self, "idle")
		else:
			Transition.emit(self, "run")

	elif InputBuffer.is_action_press_buffered("jump") and player.can_jump():
		Transition.emit(self, "jump")

	elif InputBuffer.is_action_press_buffered("attack"):
		Transition.emit(self, "attack")
		
	elif InputBuffer.is_action_press_buffered("dash") and player.can_dash():
		Transition.emit(self, "dash")


func _on_player_damage_taken() -> void:
	Transition.emit(self, "hurt")


func _on_player_death() -> void:
	Transition.emit(self, "death")
