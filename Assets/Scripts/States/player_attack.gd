extends State
class_name PlayerAttack

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_area: CollisionShape2D = $"../../AttackArea/CollisionShape2D"

# TODO: Put all these in a player class resource
@export var min_time_in_atk: float = 0.3

var atk_timer: float


func enter():
	player = get_tree().get_first_node_in_group("Player")
	
	player.current_atk_seq += 1
	#print("Entering player attack " + str(player.current_atk_seq) + " state")
	animation_player.play("attack" + str(player.current_atk_seq))

	# Setup initial atk timer
	atk_timer = min_time_in_atk

func exit():
	attack_area.disabled = true
	
	# Reset attack sequence after if this is the last in the sequence
	if player.current_atk_seq == player.no_of_basic_atks:
		player.current_atk_seq = 0


func update(_delta: float):
	if atk_timer > 0:
		atk_timer -= _delta


func physics_update(_delta: float):
	var direction := Input.get_axis("move-left", "move-right")
	
	# if player is on floor, stop the player from moving when attacking
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	else:
		player.velocity.x = direction * player.SPEED
	
	# Go to next attack sequence
	if atk_timer <= 0:
		if InputBuffer.is_action_press_buffered("attack") \
			and player.current_atk_seq < player.no_of_basic_atks:
				Transition.emit(self, "attack")
		
		# If attack animation is finished playing
		elif !animation_player.is_playing():
			
			if player.is_on_floor():
				if direction == 0 :
					Transition.emit(self, "idle")
				elif direction != 0:
					Transition.emit(self, "run")
			elif player.velocity.y > 0 and !player.is_on_floor():
				Transition.emit(self, "fall")
		
		# Allow dash to cancel attack
		elif InputBuffer.is_action_press_buffered("dash") and player.can_dash():
			Transition.emit(self, "dash")


func _on_player_damage_taken() -> void:
	Transition.emit(self, "hurt")


func _on_player_death() -> void:
	Transition.emit(self, "death")
