extends State
class_name enemyidle

var enemy: Node2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"



func enter():
	enemy = get_tree().get_first_node_in_group("Node2D")
	animation_player.play("idle")


func exit():
	pass

func physics_update(_delta: float):
	pass


func _on_enemy_damage_taken():
	Transition.emit(self, "hurt")
