extends Node2D

const SPEED = 60

signal damage_taken
signal death

@export var health = 50
@onready var animation_player: AnimationPlayer = $AnimationPlayer














#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	##position.x += delta * SPEED
	#pass
#
## Call this method when you want the 
#func take_damage(dmg_taken: int):
	#health -= dmg_taken
	#
	#if health <= 0:
		#animation_player.play("death")
	#else:
		#animation_player.play("hurt")
