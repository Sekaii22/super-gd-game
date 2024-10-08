extends RayCast2D

signal player_detected

var player_close: bool = false
var player
var enemy
@export var raycast_scale: float

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	enemy = get_tree().get_first_node_in_group("Enemy")

func _physics_process(delta: float) -> void:
	target_position = player.position - enemy.position
	target_position = target_position.normalized() * raycast_scale
	check_player()

func check_player():
	if is_colliding() && get_collider().name == "Player":
		player_close = true
		player_detected.emit()
	else:
		player_close = false
