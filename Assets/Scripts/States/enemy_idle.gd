extends State
class_name EnemyIdle

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var enemy: Node2D = $"../.."
@onready var ray_cast_2d: RayCast2D = $"../../RayCast2D"

func enter():
	#enemy = get_tree().get_first_node_in_group("Enemy")
	print("Entering enemy idle state")
	animation_player.play("idle")

func exit():
	pass

func physics_update(_delta: float):
	pass

func _on_enemy_damage_taken() -> void:
	Transition.emit(self, "hurt")

func _on_enemy_death() -> void:
	Transition.emit(self, "death")

func _on_player_tracker_player_detected() -> void:
	Transition.emit(self, "hurt")
