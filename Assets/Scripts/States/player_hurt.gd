extends State
class_name PlayerHurt

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter():
	player = get_tree().get_first_node_in_group("Player")
	print("Entering player hurt state")
	animation_player.play("hurt")
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	var direction := Input.get_axis("move-left", "move-right")
	player.velocity.x = direction * player.SPEED
	
	# TODO: Find a better way. This implementation is preventing the player from jumping and attacking
	# when in the hurt state
	if !animation_player.is_playing():
		if direction == 0:
			Transition.emit(self, "idle")
		else:
			Transition.emit(self, "run")
		
		if Input.is_action_just_pressed("jump") and player.is_on_floor():
			Transition.emit(self, "jump")
			
		if Input.is_action_just_pressed("attack"):
			Transition.emit(self, "attack")


func _on_player_death() -> void:
	Transition.emit(self, "death")