extends State
class_name EnemyIdle

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var player_tracker: RayCast2D = $"../../PlayerTracker"
@onready var enemy: CharacterBody2D = $"../.."


func enter():
	print("Entering enemy idle state")
	animation_player.play("idle")

func exit():
	enemy.velocity = Vector2(0, 0)

func physics_update(_delta: float):
	pass

func _on_enemy_damage_taken() -> void:
	Transition.emit(self, "hurt")

func _on_enemy_death() -> void:
	Transition.emit(self, "death")

func _on_player_tracker_player_detected() -> void:
	#if enemy.exhausted == false:
		#Transition.emit(self, "alert")
	pass

func _on_player_detection_range_body_entered(body: Node2D) -> void:
	if enemy.exhausted == false:
		Transition.emit(self, "alert")
