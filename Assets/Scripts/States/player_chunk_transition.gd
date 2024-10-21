extends State
class_name PlayerChunkTransition

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

@export var time_in_transition: float = 1.0

func enter():
	player = get_tree().get_first_node_in_group("Player")
	
	print("Entering chunk transition state")
	if player.is_on_floor():
		animation_player.play("run")
	else:
		animation_player.play("fall")
	
	player.velocity.x = 1.0 * player.SPEED
	
func exit():
	player.velocity.x = 0


func update(_delta: float):
	if player.is_on_floor() and animation_player.current_animation != "fall":
		animation_player.play("run")


func physics_update(_delta: float):
	await get_tree().create_timer(time_in_transition).timeout
	
	if player.is_on_floor():
		Transition.emit(self, "idle")
