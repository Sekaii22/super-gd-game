extends RayCast2D

#Area2D checks for player
#Raycast tracks the player position

signal player_detected
signal player_escaped

var player_entered_area: bool = false
var check_for_player: bool = false
var player_close: bool = false
var player_collision_point: Vector2
var player: CharacterBody2D
var enemy: CharacterBody2D
#@export var raycast_scale: float
@export var player_detection_range: Area2D
@export var check_last_seen: Timer

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	enemy = get_parent()
	check_last_seen.start()

func _physics_process(_delta: float) -> void:
	check_player() #May need to remove
	if check_for_player == true and player_entered_area == true:
		player_collision_point = get_collision_point()
		target_position = player.global_position - enemy.global_position

		check_for_player = false #reset tracking


func check_player():
	if is_colliding() && get_collider().name == "Player":
		#print("raycast to player collision true " +get_collider().name)
		player_close = true
	elif is_colliding() && get_collider().name != "Player":
		player_close = false
	else:
		player_close = false


func _on_check_last_seen_timeout() -> void:
	check_for_player = true

func _on_player_detection_range_body_entered(body: Node2D) -> void:
	if body.name.containsn("Player"):
		player_entered_area = true #Boolean check true for player within range to activate raycast position recording
		player_detected.emit()

func _on_player_detection_range_body_exited(body: Node2D) -> void:
	print("collision point "+str(get_collision_point()))
	if body.name.containsn("Player"): #This should detect the exiting body as player...
		player_entered_area = false #Boolean check false for player within range to deactivate raycast position recording
		player_escaped.emit()
