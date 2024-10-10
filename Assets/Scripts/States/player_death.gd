extends State
class_name PlayerDeath

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter():
	player = get_tree().get_first_node_in_group("Player")
	
	print("Entering player death state")
	animation_player.play("death")
	
	# TODO: Put the game loop functionality here instead of killzone script. Reset scene on death after timer.
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
