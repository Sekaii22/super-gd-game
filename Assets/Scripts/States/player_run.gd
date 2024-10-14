extends State
class_name PlayerRun

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter():
	player = get_tree().get_first_node_in_group("Player")
	
	print("Entering player run state")
	animation_player.play("run")
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	var direction := Input.get_axis("move-left", "move-right")
	player.velocity.x = direction * player.SPEED
	
	if direction == 0 and player.is_on_floor():
		Transition.emit(self, "idle")
	
	elif InputBuffer.is_action_press_buffered("jump") and \
		(player.is_on_floor() or player.in_coyote_time):
		Transition.emit(self, "jump")
		
	elif InputBuffer.is_action_press_buffered("attack"):
		Transition.emit(self, "attack")
		
	# Player must be falling, not on floor, and coyote time has passed to transit to fall state
	elif player.velocity.y > 0 and !player.is_on_floor() and !player.in_coyote_time:
		player.jumps_left -= 1
		Transition.emit(self, "fall")
		
	elif InputBuffer.is_action_press_buffered("dash") and player.can_dash():
		Transition.emit(self, "dash")


func _on_player_damage_taken() -> void:
	Transition.emit(self, "hurt")


func _on_player_death() -> void:
	Transition.emit(self, "death")
