extends Node2D

var map_manager: Node2D


func _ready() -> void:
	map_manager = get_tree().get_first_node_in_group("MapManager")
	print(map_manager)
	map_manager.connect("PlayerEnteredTransitionZone", _handle_player_chunk_transition)


func _handle_player_chunk_transition(player: Player):
	print("Entered transition manager")
	player.enter_chunk_transition_state()
	# TODO: Move player
	# TODO: Shift camera right limit to next chunk's end point
	# TODO: map_loader.move_right_boundary_to_next()
	# TODO: Shift camera left limit to next chunk's end point
	
