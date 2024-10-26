extends State
class_name PlayerDeath

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

@export var death_time: float = 3

func enter():
	player = get_tree().get_first_node_in_group("Player")
	
	#print("Entering player death state")
	animation_player.play("death")
	
	# Restart scene after death_time
	player.lock_direction = true
	Engine.time_scale = 0.5
	await get_tree().create_timer(death_time * Engine.time_scale).timeout
	get_tree().reload_current_scene()
	Engine.time_scale = 1
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
