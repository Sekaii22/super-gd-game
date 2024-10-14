extends State
class_name PlayerIdle

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var ground_checker: RayCast2D = $"../../GroundChecker"

func enter():
	player = get_tree().get_first_node_in_group("Player")
	
	print("Entering player idle state")
	animation_player.play("idle")
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	var direction := Input.get_axis("move-left", "move-right")
	player.velocity.x = direction * player.SPEED
	
	if direction != 0 and player.is_on_floor():
		Transition.emit(self, "run")
	
	elif InputBuffer.is_action_press_buffered("jump"):
		# Used for checking if the ground can be down-jumped
		var ground_collider = ground_checker.get_collider()
		
		if Input.is_action_pressed("move-down") and ground_collider.name == "Platform":
			player.position.y += 2
		else:
			Transition.emit(self, "jump")
		
	elif InputBuffer.is_action_press_buffered("attack"):
		Transition.emit(self, "attack")
		
	elif player.velocity.y > 0 and !player.is_on_floor():
		player.jumps_left -= 1
		Transition.emit(self, "fall")
		
	elif InputBuffer.is_action_press_buffered("dash") and player.can_dash():
		Transition.emit(self, "dash")
		

func _on_player_damage_taken() -> void:
	Transition.emit(self, "hurt")


func _on_player_death() -> void:
	Transition.emit(self, "death")
