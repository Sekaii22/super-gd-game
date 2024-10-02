extends Area2D

@export var damage: int = 100

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("You take " + str(damage) + " damage!")
		body.health -= damage
		if body.health <= 0:
			print("dead")
