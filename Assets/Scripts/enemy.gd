extends Node2D

const SPEED = 60

@export var health = 50
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#position.x += delta * SPEED
	pass
	

func _on_killzone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		health -= 10
		if health <= 0:
			animation_player.play("death")
		else:
			animation_player.play("hurt")
