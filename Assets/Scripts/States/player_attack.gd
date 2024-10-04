extends State
class_name PlayerAttack

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter():
	player = get_tree().get_first_node_in_group("Player")
	print("Entering player attack state")
	animation_player.play("attack")
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	var direction := Input.get_axis("move-left", "move-right")
	
	# if player is on floor, stop the player from moving when attacking
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	else:
		player.velocity.x = direction * player.SPEED
	
	# if attack animation is finished playing
	if !animation_player.is_playing():
		if direction == 0:
			Transition.emit(self, "idle")
		else:
			Transition.emit(self, "run")


func _on_player_damage_taken() -> void:
	Transition.emit(self, "hurt")


func _on_player_death() -> void:
	Transition.emit(self, "death")
