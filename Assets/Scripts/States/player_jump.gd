extends State
class_name PlayerJump

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var jump_particle: GPUParticles2D = $"../../DoubleJumpParticle"

# TODO: Put all these in a player class resource
@export var min_time_in_jump: float = 0.2

var jump_timer: float = 0
var var_jump_factor: float = 2.0

func enter():
	player = get_tree().get_first_node_in_group("Player")
	
	print("Entering player jump state")
	player.velocity.y = player.JUMP_VELOCITY
	
	# Jump animation and particle effect
	animation_player.play("jump")
	if player.jumps_left != player.no_of_jumps:
		jump_particle.restart()
		
	player.jumps_left -= 1
	jump_timer = min_time_in_jump
	
func exit():
	pass
	
func update(_delta: float):
	if jump_timer > 0:
		jump_timer -= _delta
	
func physics_update(_delta: float):
	var direction := Input.get_axis("move-left", "move-right")
	player.velocity.x = direction * player.SPEED
	
	# Variable jump
	if Input.is_action_just_released("jump") and player.jumps_left == player.no_of_jumps - 1:
		player.velocity.y /= var_jump_factor
	
	if player.velocity.y >= 0:
		Transition.emit(self, "fall")
			
	elif InputBuffer.is_action_press_buffered("attack"):
		Transition.emit(self, "attack")
		
	elif InputBuffer.is_action_press_buffered("dash") and player.can_dash():
		Transition.emit(self, "dash")
		
	if jump_timer <= 0:
		if InputBuffer.is_action_press_buffered("jump") and player.can_jump():
			Transition.emit(self, "jump")

func _on_player_damage_taken() -> void:
	Transition.emit(self, "hurt")


func _on_player_death() -> void:
	Transition.emit(self, "death")
