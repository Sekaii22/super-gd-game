extends State
class_name PlayerDash

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var player_collision_shape: CollisionShape2D = $"../../CollisionShape2D"

var timer: float = 0
var dash_str: float = 0

# TODO: Put all these in a player class resource
@export var dash_factor: float = 5
@export var min_time_in_dash: float = 0.2

func enter():
	player = get_tree().get_first_node_in_group("Player")
	
	# Invulnerability during dash
	player.set_collision_layer_value(1, false)
	player.velocity.y = 0
	
	if !player.is_on_floor():
		player.gravity_on = false
	
	# TODO: Replace the dash animation and add dash effect
	print("Entering player dash state")
	animation_player.play("run")
	
	# Set up initial timer and dash strength
	timer = min_time_in_dash
	dash_str = player.SPEED * dash_factor
	
func exit():
	player.set_collision_layer_value(1, true)
	
func update(_delta: float):
	if timer > 0:
		timer -= _delta
	
func physics_update(_delta: float):
	var direction := Input.get_axis("move-left", "move-right")
	
	dash_str = lerp(dash_str, 0.0, 0.1)
	player.velocity.x = player.face_direction_x * dash_str
	
	if timer <= 0:
		player.gravity_on = true
		
		if player.is_on_floor():
			if direction == 0:
				Transition.emit(self, "idle")
			else:
				Transition.emit(self, "run")
			
		elif player.velocity.y > 0 and !player.is_on_floor():
			Transition.emit(self, "fall")
			
	# Allow attack to cancel dash
	if Input.is_action_just_pressed("attack"):
		player.gravity_on = true
		Transition.emit(self, "attack")
