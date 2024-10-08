extends Node2D

const SPEED = 60

signal damage_taken
signal death

@export var health = 50
@export var ray_cast_2d: RayCast2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Call this method when you want the 
func take_damage(dmg_taken: int):
	health -= dmg_taken
	print("Enemy took " + str(dmg_taken) + " damage! From take_damage function in enemy script")
	print("Enemy " +str(health)+ " left")
	
	if health <= 0:
		death.emit()
	else:
		damage_taken.emit()


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
