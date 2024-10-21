extends Node2D

## Tracks and responds to current chunk's objective cleared signal.
## If current chunk's objective is completed, move right boundary.
## Emits [b]StageObjectiveCleared[/b] when all chunks objective are cleared.

signal StageObjectiveCleared
#signal PlayerEnteredTransitionZone(Player)

@onready var map_loader: Node2D = $MapLoader

# Current latest chunk with active objective, not necessarily the chunk
# that the player is currently in.
var current_chunk = null


# Signal Handlers
func _on_map_loader_chunk_spawned(chunk_instance: Node) -> void:
	# Initialize chunk linked list
	if current_chunk == null:
		current_chunk = LinkedList.new(null, chunk_instance)
	else:
		current_chunk.push_to_end(chunk_instance)
		
	chunk_instance.connect("ChunkObjectiveCleared", _on_chunk_objective_cleared)
	#chunk_instance.connect("PlayerExitedChunk", _on_map_chunk_player_exited)


func _on_chunk_objective_cleared():
	print("Chunk cleared message received in map manager")
	# TODO: Arrow pointing to the start point of next chunk (Put code somewhere else, not here)
	
	if current_chunk != null:
		if current_chunk.value.objective_cleared:
			# Move right boundary and enable transition area
			map_loader.move_right_boundary_to_next()
			#map_loader.enable_transition_area()
			
			current_chunk = current_chunk.next


#func _on_map_chunk_player_exited(chunk_exited: MapChunk):
	#map_loader.move_transition_area()
	#map_loader.move_left_boundary_to_next()


#func _on_transition_zone_body_entered(player: Node2D) -> void:
	#print("Player in transition zone")
	#PlayerEnteredTransitionZone.emit(player)
