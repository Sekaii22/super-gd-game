extends Node2D
class_name EnemySpawner

signal OnWaveCleared
signal OnCleared

@onready var spawn_point_parent: Node2D = $SpawnPoints

## Switch to turn on/off the spawner.
@export var on_spawner: bool = true
## Key = enemy names, Values = enemy scene
@export var enemy_dictionary: Dictionary
## Key = spawn point number, Value = enemy names
@export var waves: Array[Dictionary]
## Number of times to loop the spawn of a particular wave
@export var waves_loops: Array[int]
@export var loop_wait_time: float = 1.0

var spawn_points: Array[Node2D]
var current_wave_num = 0
var initial_node_count = 0
var current_node_count = 0
var no_of_waves: int

func _ready() -> void:
	# Get all spawn point nodes
	for child in spawn_point_parent.get_children():
		spawn_points.append(child)
	
	initial_node_count = get_child_count()
	current_node_count = get_child_count()
	
	if on_spawner:
		no_of_waves = waves.size()
		spawn_next_wave()
		

## Instantiate enemy and put it in spawn_point position
func create_enemy(enemy_name: String, spawn_point: Node2D) -> Node:
	var enemy_scene = enemy_dictionary[enemy_name]
	var enemy_instance: Node2D = enemy_scene.instantiate()
	enemy_instance.global_position = spawn_point.global_position
	return enemy_instance


func spawn_next_wave() -> bool:
	if current_wave_num < no_of_waves:
		current_wave_num += 1
		
		# temp_index is used becuase of 0-indexing of arrays
		var temp_index = current_wave_num - 1
		var wave: Dictionary
		var sp_nums_used_in_wave: Array
		var no_of_loops: int = 1
		
		# Check if wave and no_of_loops exist
		if temp_index < waves.size():
			wave = waves[temp_index]
			sp_nums_used_in_wave = wave.keys()
		if temp_index < waves_loops.size():
			no_of_loops = waves_loops[temp_index]
		
		# Spawn current wave no_of_loops times
		for loop_no in no_of_loops:
			
			# Spawn all the enemies in the current wave
			for sp_num in sp_nums_used_in_wave:
				
				# Check if sp_num is a valid spawn point
				if sp_num >= 0 and sp_num - 1 < spawn_points.size():
					var spawn_point: Node2D = spawn_points[sp_num - 1]
					var enemy_name = wave[sp_num]
					if enemy_name in enemy_dictionary.keys():
						var enemy: Node2D = create_enemy(enemy_name, spawn_point)
						add_child(enemy)

			# Wait abit before looping
			await get_tree().create_timer(loop_wait_time).timeout

		return true
	else:
		return false


# DEBUG CODE
func _on_cleared_button_pressed() -> void:
	OnCleared.emit()
