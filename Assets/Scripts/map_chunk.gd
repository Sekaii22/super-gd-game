extends Node2D
class_name MapChunk

## Represents the overall objective of the chunk.
## When all objective components are cleared, [b]ChunkObjectiveCleared[/b] signal is emitted.

signal ChunkObjectiveCleared
signal PlayerEnteredChunk(MapChunk)

## A node that implements the OnCleared signal.
@export var obj_node_to_be_tracked: ChunkObjective
@export var disable_enemy_spawn: bool = false

var objective_cleared = false
var chunk_pos: int
var left_limit: int
var right_limit: int


func _ready() -> void:
	if obj_node_to_be_tracked:
		obj_node_to_be_tracked.connect("OnCleared", _on_cleared)


# Signal Handlers
func _on_cleared():
	objective_cleared = true
	print("Chunk's objective is cleared")
	ChunkObjectiveCleared.emit()


# Start the chunk objective on enter, e.g. start spawning enemies.
func _on_chunk_zone_body_entered(_body: Node2D) -> void:
	print("Entered ", self.name)
	PlayerEnteredChunk.emit(self)

	if !disable_enemy_spawn:
		# Check for obj type and if the obj has been started alr
		if obj_node_to_be_tracked.objective == ChunkObjective.OBJECTIVE_TYPE.KILL_ENEMIES \
			and obj_node_to_be_tracked.started == false:
			await get_tree().create_timer(1.0).timeout
			
			# Start the enemy spawn
			obj_node_to_be_tracked.spawn_next_wave()

	# TODO: add for other objective type
	#elif obj_node_to_be_tracked.objective == ChunkObjective.OBJECTIVE_TYPE.PLATFORMER:
		#pass
