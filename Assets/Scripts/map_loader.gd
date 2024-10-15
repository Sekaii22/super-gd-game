extends Node2D

## Responsible for loading the stage by selecting randomly from a list of chunks,
## and moving the left right boundaries.

signal ChunkSpawned(chunk: Node)

@onready var boundary_left: StaticBody2D = $BoundaryLeft
@onready var boundary_right: StaticBody2D = $BoundaryRight
@onready var transition_area: Area2D = $TransitionArea

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


func _ready() -> void:
	#var no_of_chunks_to_spawn = min(chunks_per_map, chunk_resources.size())
	# DEBUG CODE
	var no_of_chunks_to_spawn = chunks_per_map
	
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

		var chunck_res = chunk_resources[temp_chunk_index]
		var chunk_instance = chunck_res.chunk_scene.instantiate()

		# Calculate position to spawn the chunk as child
		var x_pos = start.x + (chunck_res.start_point.x * -1)
		var y_pos = start.y + (chunck_res.start_point.y * -1)
		chunk_instance.global_position = Vector2(x_pos, y_pos)
		add_child(chunk_instance)
		ChunkSpawned.emit(chunk_instance)

		# Calculate new start point,
		# abs() for x since it will always be moving to the right,
		# whereas y can go up and down
		start.x = start.x + abs(chunck_res.end_point.x - chunck_res.start_point.x)
		start.y = start.y + (chunck_res.end_point.y - chunck_res.start_point.y)
		boundary_vector_arr.append(Vector2(start.x, start.y))

	# Setup left right boundaries
	boundary_left.position.x = boundary_vector_arr[0].x
	boundary_right.position.x = boundary_vector_arr[1].x

	# Setup transition area
	move_transition_area()


func _physics_process(_delta: float) -> void:
	# Shifts boundary gradually
	boundary_left.position.x = lerp(boundary_left.position.x, \
		boundary_vector_arr[current_left_boundary_index].x, 0.05)
	boundary_right.position.x = lerp(boundary_right.position.x, \
		boundary_vector_arr[current_right_boundary_index].x, 0.05)


func move_left_boundary_to_next():
	if current_left_boundary_index < current_right_boundary_index - 1:
		current_left_boundary_index += 1


func move_right_boundary_to_next():
	if current_right_boundary_index < boundary_vector_arr.size() - 1:
		current_right_boundary_index += 1


func move_transition_area():
	transition_area.position = boundary_vector_arr[current_right_boundary_index]

# Debug code
func _on_area_2d_body_entered(_body: Node2D) -> void:
	print("Current right boundary ", current_right_boundary_index)
	print("Current left boundary ", current_left_boundary_index)
	move_right_boundary_to_next()
	move_transition_area()
	print("Current right boundary ", current_right_boundary_index)
	print("Current left boundary ", current_left_boundary_index)
