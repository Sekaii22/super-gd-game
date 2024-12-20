extends State
class_name PlayerDash

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var dash_particle: GPUParticles2D = $"../../DashParticle"

# TODO: Put all these in a player class resource
#@export var min_time_in_dash: float = 0.25
@export var dash_factor: float = 6
@export var dash_left_particle_tex: Texture2D
@export var dash_right_particle_tex: Texture2D
@export var dash_particle_offset_x: int = -22

#var dash_timer: float = 0
var dash_str: float = 0

func enter():
	player = get_tree().get_first_node_in_group("Player")
	
	# Play dash animation
	if !player.is_on_floor():
		player.velocity.y = 0
		player.gravity_on = false
		animation_player.play("air_dash")
	else:
		animation_player.play("dash")
	
	#print("Entering player dash state")
	player.dashes_left -= 1
	
	# TODO: Change particle effect depending if player is on floor or air
	
	# Set dash particle effect direction
	if player.face_direction_x == 1:
		# Facing left
		dash_particle.texture = dash_right_particle_tex
		dash_particle.process_material.emission_shape_offset.x = dash_particle_offset_x
	else:
		# Facing right
		dash_particle.texture = dash_left_particle_tex
		dash_particle.process_material.emission_shape_offset.x = -dash_particle_offset_x
	dash_particle.restart()
	
	# Set up initial timer and dash strength
	#dash_timer = min_time_in_dash
	#dash_timer = animation_player.current_animation_length * 0.85
	dash_str = player.SPEED * dash_factor
	
func exit():
	# In the case where attacks cancel the dash animation
	player.set_collision_layer_value(6, true)
	player.set_collision_layer_value(7, false)
	
func update(_delta: float):
	pass
	#if dash_timer > 0:
		#dash_timer -= _delta
	
func physics_update(_delta: float):
	var direction := Input.get_axis("move-left", "move-right")
	
	dash_str = lerp(dash_str, 0.0, 0.1)
	player.velocity.x = player.face_direction_x * dash_str
	
	# Dash action can be done without waiting for current dash to fully finish
	#if dash_timer <= 0:
		#if InputBuffer.is_action_press_buffered("dash") and player.can_dash():
			#player.gravity_on = true
			#Transition.emit(self, "dash")

	if !animation_player.is_playing():
		player.gravity_on = true

		if player.is_on_floor():
			if direction == 0:
				Transition.emit(self, "idle")
			else:
				Transition.emit(self, "run")

		elif player.velocity.y > 0 and !player.is_on_floor():
			Transition.emit(self, "fall")

	# Allow attack to cancel dash
	if InputBuffer.is_action_press_buffered("attack"):
		player.gravity_on = true
		Transition.emit(self, "attack")
		
	
