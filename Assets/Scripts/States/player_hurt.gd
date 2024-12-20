extends State
class_name PlayerHurt

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var animation_player_2: AnimationPlayer = $"../../AnimationPlayer2"

func enter():
	player = get_tree().get_first_node_in_group("Player")
	
	#print("Entering player hurt state")
	animation_player.play("hurt")
	animation_player_2.play("invulnerable")
	
	# TODO: Find a better way for upwards knockback pls
	player.velocity = player.knockback
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	var direction := Input.get_axis("move-left", "move-right")
	
	# knockback x is lerped in player.gd while knockback y is taken care by gravity
	player.velocity.x = player.knockback.x
	
	if !animation_player.is_playing():
		if player.is_on_floor():
			if direction == 0:
				Transition.emit(self, "idle")
			else:
				Transition.emit(self, "run")
		elif player.velocity.y > 0 and !player.is_on_floor():
			player.jumps_left -= 1
			Transition.emit(self, "fall")


func _on_player_death() -> void:
	Transition.emit(self, "death")
