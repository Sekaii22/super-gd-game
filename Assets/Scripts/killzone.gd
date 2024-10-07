extends Area2D

@export var damage: int = 100
@export var knockback_str: float = 10.0
@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.take_damage(damage)
		body.take_knockback(self, knockback_str)
		
		if body.health <= 0:
			Engine.time_scale = 0.5
			timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale = 1
