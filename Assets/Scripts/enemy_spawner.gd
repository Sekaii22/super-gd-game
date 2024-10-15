extends Node2D
class_name EnemySpawner

signal OnWaveCleared
signal OnCleared

@onready var spawn_point_parent: Node2D = $SpawnPoints

## Key = enemy names, Values = enemy scene
@export var on_spawner: bool = true
@export var enemy_dictionary: Dictionary
@export var no_of_waves: int

## Key = spawn point number, Value = enemy names
# TODO: Convert to an array of waves
@export var wave1: Dictionary
@export var wave2: Dictionary
@export var wave3: Dictionary

## Number of times to loop the spawn of a particular wave of enemy
# TODO: Convert to an array of loop no
@export var wave1_loop_no: int = 1
@export var wave2_loop_no: int = 1
@export var wave3_loop_no: int = 1
@export var loop_wait_time: float = 1.0

var spawn_points: Array[Node2D]
var current_wave = 0
var initial_node_count = 0
var current_node_count = 0

func _ready() -> void:
	# Get all spawn point nodes
	for child in spawn_point_parent.get_children():
		spawn_points.append(child)
	
	initial_node_count = get_child_count()
	current_node_count = get_child_count()
	
	if on_spawner:
		spawn_next_wave()

## Instantiate enemy and put it in position
func create_enemy(enemy_name: String, spawn_point: Node2D) -> Node:
	var enemy_scene = enemy_dictionary[enemy_name]
	var enemy_instance: Node2D = enemy_scene.instantiate()
	enemy_instance.global_position = spawn_point.global_position
	return enemy_instance


func spawn_next_wave() -> bool:
	if current_wave < no_of_waves:
		current_wave += 1
		
		# TODO: Make it work with an array of waves
		if current_wave == 1:
			var spawn_point_nums = wave1.keys()
			
			
			for loop_no in wave1_loop_no:
				
				for sp_num in spawn_point_nums:
					var spawn_point: Node2D = spawn_points[sp_num - 1]
					var enemy = create_enemy(wave1[sp_num], spawn_point)
					add_child(enemy)
				await get_tree().create_timer(loop_wait_time).timeout
					
			
		return true
	else:
		return false


func _on_cleared_button_pressed() -> void:
	OnCleared.emit()
