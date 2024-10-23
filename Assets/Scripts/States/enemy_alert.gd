extends State
class_name EnemyAlert

@export var enemy: CharacterBody2D
@onready var player_tracker: RayCast2D = $"../../PlayerTracker"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter():
	print("Entering enemy alert state")
	animation_player.play("alert")

func exit():
	enemy.velocity = Vector2(0, 0)

func update(_delta: float):
	if !animation_player.is_playing() && player_tracker.player_entered_area:
		Transition.emit(self, "run")
		#Player escapes from raycast before animation ends


func physics_update(_delta: float):
	pass

func _on_enemy_damage_taken() -> void:
	Transition.emit(self, "hurt")

func _on_enemy_death() -> void:
	Transition.emit(self, "death")


func _on_player_tracker_player_escaped() -> void:
	Transition.emit(self, "idle")
