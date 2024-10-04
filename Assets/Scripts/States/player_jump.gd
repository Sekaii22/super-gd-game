extends State
class_name PlayerJump

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter():
	player = get_tree().get_first_node_in_group("Player")
	print("Entering player jump state")
	player.velocity.y = player.JUMP_VELOCITY
	
	# TODO: Change the jump animation
	animation_player.play("jump")
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	var direction := Input.get_axis("move-left", "move-right")
	player.velocity.x = direction * player.SPEED
	
	if player.is_on_floor():
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
