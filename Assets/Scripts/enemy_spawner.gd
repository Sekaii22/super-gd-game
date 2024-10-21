extends ChunkObjective
class_name EnemySpawner

signal OnWaveCleared

## EnemySpawner node needs to have a SpawnPoints child node containing
## spawn points marker node.
@onready var spawn_point_parent: Node2D = $SpawnPoints

## Switch to turn on/off the spawner.
@export var spawn_on_start: bool = false
## Key = enemy names, Values = enemy scene
@export var enemy_dictionary: Dictionary
## An array of waves. Each element in the array is a dictionary 
## representing a single wave of enemy.
## Key = spawn point number, Value = enemy names
@export var waves: Array[Dictionary]
## Number of times to loop the spawn of a particular wave of enemy.
@export var waves_loops: Array[int]
## Time between each loop
@export var loop_wait_time: float = 2.5
## Time between each wave
@export var wave_wait_timer: float = 1.0

var spawn_points: Array[Node2D]
var current_wave_num: int = 0
var wave_is_spawning: bool = false
var initial_node_count: int = 0
var current_node_count: int = 0
var no_of_waves: int

func _ready() -> void:
	# Get all spawn point nodes
	for child in spawn_point_parent.get_children():
		spawn_points.append(child)
	
	initial_node_count = get_child_count()
	current_node_count = get_child_count()
	no_of_waves = waves.size()
	
	if spawn_on_start:
		spawn_next_wave()


func _process(_delta: float) -> void:
	if !wave_is_spawning and !finished:
		current_node_count = get_child_count()
		
		# Check if the wave is cleared
		if current_node_count == initial_node_count and current_wave_num != 0:
			OnWaveCleared.emit()
			
			if current_wave_num < no_of_waves:
				await get_tree().create_timer(wave_wait_timer).timeout
				spawn_next_wave()
			elif current_wave_num == no_of_waves:
				finished = true
				OnCleared.emit()


func spawn_next_wave() -> bool:
	if started == false:
		started = true
	
	if current_wave_num < no_of_waves:
		wave_is_spawning = true
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
				if sp_num > 0 and sp_num <= spawn_points.size():
					# sp_num cause of 0-indexing of spawn_points array
					var spawn_point: Node2D = spawn_points[sp_num - 1]
					var enemy_name: String = wave[sp_num]

					if enemy_name in enemy_dictionary.keys():
						var enemy: Node2D = create_enemy(enemy_name, spawn_point)
						enemy.name = "Enemy_" + str(enemy.get_instance_id()) + "_" + enemy_name
						add_child(enemy)

			# Wait abit before looping
			await get_tree().create_timer(loop_wait_time).timeout

		wave_is_spawning = false
		return true

	else:
		return false


## Instantiate enemy and put it in spawn_point position
func create_enemy(enemy_name: String, spawn_point: Node2D) -> Node:
	var enemy_scene: PackedScene = enemy_dictionary[enemy_name]
	var enemy_instance: Node2D = enemy_scene.instantiate()
	
	# Local position is needed to be used here to get it to work
	enemy_instance.position = spawn_point.position
	
	# TODO: Add spawn effects
	return enemy_instance


# DEBUG CODE
func _on_cleared_button_pressed() -> void:
	OnCleared.emit()
