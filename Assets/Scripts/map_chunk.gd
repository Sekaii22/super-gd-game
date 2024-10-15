extends Node2D
class_name MapChunk

## Represents the overall objective of the chunk.
## When all objective components are cleared, [b]ChunkObjectiveCleared[/b] signal is emitted.


enum OBJECTIVE_TYPE {KILL_ENEMIES, PLATFORMER}

signal ChunkObjectiveCleared

## Not in used.
@export var objective: OBJECTIVE_TYPE
## A node that implements the OnCleared signal.
@export var obj_node_to_be_tracked: Node

var objective_cleared = false


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
