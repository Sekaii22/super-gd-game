extends Node2D

@export var chunk_resources: Array[ChunkResource]
@export var chunks_per_map: int = 1
@export var start: Vector2

func _ready() -> void:
	for i in chunks_per_map:
		# Get random chunk resource and instantiate it
		# TODO: to not allow duplicate chunk
		var rand_index = randi_range(0, chunk_resources.size() - 1)
		var chunck_res = chunk_resources[rand_index]
		var chunk_instance = chunck_res.chunk_scene.instantiate()
		
		# Calculate position to spawn the chunk as child
		var x_pos = start.x + (chunck_res.start_point.x * -1)
		var y_pos = start.y + (chunck_res.start_point.y * -1)
		chunk_instance.global_transform = Transform2D(0, Vector2(x_pos, y_pos))
		add_child(chunk_instance)
		
		# Calculate new start point
		# abs() for x since it will always be moving to the right
		# whereas y can go up and down
		start.x = start.x + abs(chunck_res.end_point.x - chunck_res.start_point.x)
		start.y = start.y + (chunck_res.end_point.y - chunck_res.start_point.y)
