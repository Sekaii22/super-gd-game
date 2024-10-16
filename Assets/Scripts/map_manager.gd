extends Node2D

## Tracks and responds to current chunk's objective cleared signal.
## If current chunk's objective is completed, move right boundary.
## If player is in the next chunk, move left boundary.
## Arrow indicator pointing towards next chunk starting location when
## objective is completed.
## Emits [b]StageObjectiveCleared[/b] when all chunks objective are cleared.

signal StageObjectiveCleared

@onready var map_loader: Node2D = $MapLoader

var current_chunk = null


# Signal Handlers
func _on_map_loader_chunk_spawned(chunk_instance: Node) -> void:
	# Initialize chunk linked list
	if current_chunk == null:
		current_chunk = LinkedList.new(null, chunk_instance)
	else:
		current_chunk.push_to_end(chunk_instance)
		
	chunk_instance.connect("ChunkObjectiveCleared", _on_chunk_objective_cleared)


func _on_chunk_objective_cleared():
	print("Chunk cleared message received in map manager")
	# TODO: Arrow pointing to the start point of next chunk


func _on_transition_area_body_entered(body: Node2D) -> void:
	if current_chunk != null:
		if current_chunk.value.objective_cleared and body.name == "Player":
			# Move right boundary and transition area
			map_loader.move_right_boundary_to_next()
			
			# TODO: Add player transit animation to next chunk.
			# TODO: Move camera right limit to the end point of the next chunk.
			# TODO: Add camera shifts.
			# map_loader.move_left_boundary_to_next()
			# TODO: Move camera left limit to start point of next chunk.
			current_chunk = current_chunk.next
