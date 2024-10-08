extends State
class_name EnemyRun

var from_run: bool = false
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var enemy: Node2D = $"../.."
@onready var player_tracker: RayCast2D = $"../../PlayerTracker"

func enter():
	#enemy = get_tree().get_first_node_in_group("Enemy")
	print("Entering enemy run state")
	animation_player.play("run")

func exit():
	pass

func physics_update(_delta: float):
	pass

func _on_enemy_damage_taken() -> void:
	from_run = true
	Transition.emit(self, "hurt")


func _on_enemy_death() -> void:
	Transition.emit(self, "death")
