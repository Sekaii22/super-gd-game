extends Node2D
class_name CameraManager

var cameras: Array[PhantomCamera2D] = []

func _on_map_manager_chunk_spawned(chunk_instance: Node2D) -> void:
	chunk_instance.connect("PlayerEnteredChunk", on_player_entered_chunk)
	var camera: PhantomCamera2D = chunk_instance.get_node("PhantomCamera")
	
	# Camera settings
	if camera.follow_mode != camera.FollowMode.NONE:
		camera.follow_target = Global.player
	camera.limit_left = chunk_instance.left_limit
	camera.limit_right = chunk_instance.right_limit
	
	cameras.append(camera)


func on_player_entered_chunk(chunk: MapChunk):
	print("Player entered received in camera manager")
	var camera = chunk.get_node("PhantomCamera")
	Global.player_chunk_pos = chunk.chunk_pos
	update_camera(camera)


func update_camera(camera: PhantomCamera2D):
	for camera_instance in cameras:
		camera_instance.priority = 0
		
	camera.priority = 1
