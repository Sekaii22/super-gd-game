extends State
class_name EnemyAlert

var direction
@export var enemy: CharacterBody2D
@onready var player_tracker: RayCast2D = $"../../PlayerTracker"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"

func enter():
	print("Entering enemy alert state")
	animation_player.play("alert")

func exit():
	enemy.velocity = Vector2(0, 0)

func update(_delta: float):
	if !animation_player.is_playing() && player_tracker.player_entered_area and player_tracker.player_close == true:
		Transition.emit(self, "run")
		#Player escapes from raycast before animation ends


func physics_update(_delta: float):
	direction = player_tracker.target_position.normalized()
	if direction.x > 0:
		animated_sprite.flip_h = true #changed for pig enemy since default is face left, thief face right
	elif direction.x < 0:
		animated_sprite.flip_h = false

func _on_enemy_damage_taken() -> void:
	Transition.emit(self, "hurt")

func _on_enemy_death() -> void:
	Transition.emit(self, "death")


func _on_player_tracker_player_escaped() -> void:
	Transition.emit(self, "idle")
