extends Area2D

@export var damage: int = 100
@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("You take " + str(damage) + " damage!")
		body.health -= damage
		if body.health <= 0:
			print("dead")
			Engine.time_scale = 0.5
			timer.start()
			


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
