extends State
class_name EnemyAlert

@onready var player_tracker: RayCast2D = $"../../PlayerTracker"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter():
	print("Entering enemy alert state")
	animation_player.play("alert")

func exit():
	pass

func update(_delta: float):
	if !animation_player.is_playing() && player_tracker.player_close:
		Transition.emit(self, "run")
		#Player escapes from raycast before animation ends
	if !animation_player.is_playing() && !player_tracker.player_close:
		Transition.emit(self, "idle")

func physics_update(_delta: float):
	pass

func _on_enemy_damage_taken() -> void:
	Transition.emit(self, "hurt")

func _on_enemy_death() -> void:
	Transition.emit(self, "death")
