extends Node2D
class_name MapChunk

## Represents the overall objective of the chunk.
## When all objective components are cleared, [b]ChunkObjectiveCleared[/b] signal is emitted.

signal ChunkObjectiveCleared
signal PlayerEnteredChunk(Node)
signal PlayerExitedChunk(Node)

## A node that implements the OnCleared signal.
@export var obj_node_to_be_tracked: ChunkObjective

var objective_cleared = false
var player_is_in_chunk = false


func _ready() -> void:
	if obj_node_to_be_tracked:
		obj_node_to_be_tracked.connect("OnCleared", _on_cleared)


# Signal Handlers
func _on_cleared():
	# TODO: There is a bug where enemy can still be hit after hp reaches 0
	# when attacking fast enough causing no_of_objective_components
	# to be reduced multiple times.

	objective_cleared = true
	print("Chunk's objective is cleared")
	ChunkObjectiveCleared.emit()


func _on_chunk_area_body_entered(_body: Node2D) -> void:
	print("Entered ", self.name)
	PlayerEnteredChunk.emit(self)

	if obj_node_to_be_tracked.objective == ChunkObjective.OBJECTIVE_TYPE.KILL_ENEMIES:
		await get_tree().create_timer(1.0).timeout
		obj_node_to_be_tracked.spawn_next_wave()

	# TODO: add for other objective type
	#elif obj_node_to_be_tracked.objective == ChunkObjective.OBJECTIVE_TYPE.PLATFORMER:
		#pass


func _on_chunk_area_body_exited(_body: Node2D) -> void:
	print("Exited ", self.name)
	PlayerExitedChunk.emit(self)
