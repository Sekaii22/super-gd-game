extends Area2D

@export var damage: int = 100
@export var knockback_x_str: float = 300.0

func _on_body_entered(body: Node2D) -> void:
	if body.name.containsn("Player"):
		body.take_damage(damage)
		body.take_knockback(self, knockback_x_str)
