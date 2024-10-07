extends State
class_name PlayerRun

var player: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter():
	player = get_tree().get_first_node_in_group("Player")
	print("Entering player run state")
	animation_player.play("run")
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	var direction := Input.get_axis("move-left", "move-right")
	player.velocity.x = direction * player.SPEED
	
	if direction == 0 and player.velocity.y <= 0.01:
		Transition.emit(self, "idle")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		Transition.emit(self, "jump1")
		
	if Input.is_action_just_pressed("attack"):
		Transition.emit(self, "attack")
		
	if player.velocity.y > 0 and !player.is_on_floor():
		Transition.emit(self, "fall1")


func _on_player_damage_taken() -> void:
	Transition.emit(self, "hurt")


func _on_player_death() -> void:
	Transition.emit(self, "death")
