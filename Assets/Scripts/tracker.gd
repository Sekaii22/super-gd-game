extends RayCast2D

signal player_detected
signal player_escaped

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
		#print("raycast to player collision true" +get_collider().name)
		player_close = true
		player_detected.emit()
	elif is_colliding() && get_collider().name != "Player":
		#print("raycast to player collision false" +get_collider().name)
		player_close = false
		player_escaped.emit()
	else:
		player_close = false
		player_escaped.emit()
