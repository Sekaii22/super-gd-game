extends RayCast2D

signal player_detected
signal player_escaped

var player_close: bool = false
var player
var enemy
@export var raycast_scale: float

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	enemy = get_parent()

func _physics_process(delta: float) -> void:
	target_position = enemy.global_position.direction_to(player.global_position) * raycast_scale
	check_player()

func check_player():
	if is_colliding() && get_collider().name == "Player":
		#print("raycast to player collision true" +get_collider().name)
		player_close = true
		player_detected.emit()
	elif is_colliding() && get_collider().name != "Player":
		player_close = false
		player_escaped.emit() #keeps hitting the map when enemy is above player
	else:
		player_close = false
		player_escaped.emit()
