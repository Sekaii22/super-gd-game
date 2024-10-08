extends State
class_name EnemyAlert

@onready var enemy: Node2D = $"../.."
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter():
	#enemy = get_tree().get_first_node_in_group("Enemy")
	animation_player.play("alert")

func exit():
	pass

func update(_delta: float):
	if !animation_player.is_playing():
		Transition.emit(self, "run")

func physics_update(_delta: float):
	pass

func _on_enemy_damage_taken() -> void:
	Transition.emit(self, "hurt")

func _on_enemy_death() -> void:
	Transition.emit(self, "death")
