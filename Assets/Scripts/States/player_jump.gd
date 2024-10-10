extends State
class_name PlayerJump

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var jump_particle: GPUParticles2D = $"../../DoubleJumpParticle"

func enter():
	player = get_tree().get_first_node_in_group("Player")
	
	print("Entering player jump state")
	player.velocity.y = player.JUMP_VELOCITY
	
	# Jump animation and particle effect
	animation_player.play("jump")
	if player.jumps_left != player.no_of_jumps:
		jump_particle.restart()
	player.jumps_left -= 1
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	var direction := Input.get_axis("move-left", "move-right")
	player.velocity.x = direction * player.SPEED
	
	if player.velocity.y > 0:
		Transition.emit(self, "fall")
	
	elif Input.is_action_just_pressed("jump") and player.can_jump():
		Transition.emit(self, "jump")
			
	elif Input.is_action_just_pressed("attack"):
		Transition.emit(self, "attack")
		
	elif Input.is_action_just_pressed("dash") and player.can_dash():
		Transition.emit(self, "dash")


func _on_player_damage_taken() -> void:
	Transition.emit(self, "hurt")


func _on_player_death() -> void:
	Transition.emit(self, "death")
