extends Node2D

## Responsible for loading the stage by selecting randomly from a list of chunks.
## Tracks and responds to current chunk's objective cleared signal.
## If current chunk's objective is completed, move right boundary.
## Emits [b]StageObjectiveCleared[/b] when all chunks objective are cleared.

signal ChunkSpawned(chunk: Node2D)
signal StageObjectiveCleared

@onready var boundary_left: StaticBody2D = $BoundaryLeft
@onready var boundary_right: StaticBody2D = $BoundaryRight

## An array of chunks that can be loaded.
## Last element of chunk_resources is reserved for the boss chunk resource.
@export var chunk_resources: Array[ChunkResource]
## No of chunks to spawn. If number is greater than the size of chunk_resources,
## min value of the two is taken.
@export var chunks_per_map: int = 1
## Starting point to spawn chunks.
@export var start: Vector2

# Boundaries
var boundary_vector_arr: Array[Vector2] = [Vector2(0, 0)]
var current_left_boundary_index = 0
var current_right_boundary_index = 1

# Track the chunk with active objective, not necessarily the chunk
# that the player is currently in.
var current_chunk: Node2D = null
var current_chunk_index: int
var chunks_list: Array[MapChunk]

# Tracking chunk and stage completion
var no_of_chunks_to_spawn
var no_of_chunks_completed: int = 0
var stage_completed: bool = false


func _ready() -> void:
	# Set global chunks list reference
	Global.chunks_list = chunks_list
	load_map()


func load_map():
	# Ensures valid number
	#var no_of_chunks_to_spawn = min(chunks_per_map, chunk_resources.size())
	# DEBUG CODE
	no_of_chunks_to_spawn = chunks_per_map
	
	# Load the chunks
	for i in no_of_chunks_to_spawn:
		var temp_chunk_index: int
		# TODO: to not allow duplicate chunk
		# Get random non-boss chunk resource except and instantiate it
		#if i < chunks_per_map - 1:
			#var rand_index = randi_range(0, chunk_resources.size() - 2)
			#temp_chunk_index = rand_index
		#else:
			## If this is the last chunk to spawn, spawn the boss chunk resource
			#temp_chunk_index = chunk_resources.size() - 1

		# DEBUG CODE
		temp_chunk_index = randi_range(0, chunk_resources.size() - 1)

		# Instantiate chunk
		var chunck_res = chunk_resources[temp_chunk_index]
		var chunk_instance = chunck_res.chunk_scene.instantiate()

		# Calculate position to spawn the chunk as child
		var x_pos = start.x + (chunck_res.start_point.x * -1)
		var y_pos = start.y + (chunck_res.start_point.y * -1)
		
		# Set chunk settings
		chunk_instance.global_position = Vector2(x_pos, y_pos)
		chunk_instance.name = "chunk_" + str(i+1)
		chunk_instance.chunk_pos = i+1
		chunk_instance.left_limit = start.x
		add_child(chunk_instance)

		# Calculate new start point for next chunk,
		# abs() for x since it will always be moving to the right,
		# whereas y can go up and down
		start.x = start.x + abs(chunck_res.end_point.x - chunck_res.start_point.x)
		start.y = start.y + (chunck_res.end_point.y - chunck_res.start_point.y)
		boundary_vector_arr.append(Vector2(start.x, start.y))

		chunk_instance.right_limit = start.x
		ChunkSpawned.emit(chunk_instance)

	# Setup initial left right boundaries
	boundary_left.position = boundary_vector_arr[0]
	boundary_right.position = boundary_vector_arr[1]


func move_left_boundary_to_next():
	if current_left_boundary_index < current_right_boundary_index - 1:
		current_left_boundary_index += 1
		boundary_left.position = boundary_vector_arr[current_left_boundary_index]


func move_right_boundary_to_next():
	if current_right_boundary_index < boundary_vector_arr.size() - 1:
		current_right_boundary_index += 1
		boundary_right.position = boundary_vector_arr[current_right_boundary_index]


# Signal Handlers
func _on_chunk_spawned(chunk_instance: Node2D) -> void:
	# Initialize chunk list
	if current_chunk == null:
		chunks_list.append(chunk_instance)
		current_chunk = chunk_instance
		current_chunk_index = 0
	else:
		chunks_list.append(chunk_instance)
	
	# Connect to objective cleared signal from each chunk
	chunk_instance.connect("ChunkObjectiveCleared", _on_chunk_objective_cleared)


func _on_chunk_objective_cleared():
	print("Chunk cleared message received from map manager")
	# TODO: Arrow pointing to the start point of next chunk (Put code somewhere else, not here)
	
	if stage_completed == false:
		if current_chunk.objective_cleared:
			# Move right boundary and enable transition area
			move_right_boundary_to_next()
			
			no_of_chunks_completed += 1
			
			# Update active chunk
			if current_chunk_index + 1 <= chunks_list.size() - 1:
				current_chunk_index += 1
				current_chunk = chunks_list[current_chunk_index]
	
		# Check for stage completion
		if no_of_chunks_to_spawn == no_of_chunks_completed:
			print("Stage completed!")
			StageObjectiveCleared.emit()
			stage_completed = true
