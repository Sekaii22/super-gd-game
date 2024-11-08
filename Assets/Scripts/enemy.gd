extends CharacterBody2D

const SPEED = 50.0
const JUMP_VELOCITY = -310.0

signal damage_taken
signal death

var from_run: bool = false
var exhausted: bool = false
@export var health = 50
@export var player_tracker: RayCast2D
@export var damage = 10
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_area: CollisionShape2D = $AttackRange/CollisionShape2D
@onready var player_detection_shape: CollisionShape2D = $PlayerTracker/PlayerDetectionRange/CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


# Call this method when you want the 
func take_damage(dmg_taken: int):
	health -= dmg_taken
	print("Enemy took " + str(dmg_taken) + " damage! From take_damage function in enemy script")
	print("Enemy " +str(health)+ " left")
	
	if health <= 0:
		death.emit()
	else:
		damage_taken.emit()

func _physics_process(delta: float) -> void:
	#Flip player detection collision shape
	if animated_sprite.flip_h == true:
		player_detection_shape.position.x = abs(player_detection_shape.position.x)
	if animated_sprite.flip_h == false:
		player_detection_shape.position.x = -abs(player_detection_shape.position.x)
	#movement
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

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

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.name.containsn("Player"):
		body.take_damage(damage)
		attack_area.set_deferred("disabled", true)


func _on_exhaust_reset_timeout() -> void:
	exhausted = false
