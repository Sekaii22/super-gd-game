extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -310.0

signal damage_taken
signal death

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area_collision_shape: CollisionShape2D = $AttackArea/CollisionShape2D

@export var health = 100
@export var damage = 10
@export var attack_area_left: float
@export var attack_area_right: float

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# direction = -1, 0, 1
	var direction := Input.get_axis("move-left", "move-right")
	
	# Flip sprite direction and attack collision area
	if direction == -1:
		animated_sprite.flip_h = true
		attack_area_collision_shape.position.x = attack_area_left
	elif direction == 1:
		animated_sprite.flip_h = false
		attack_area_collision_shape.position.x = attack_area_right
	
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:	
	if area.get_parent().name == "Enemy":
		area.get_parent().take_damage(damage)

# Call this method when you want the player to take damage
# TODO: countdown timer until damage can be taken again
func take_damage(dmg_taken: int):
	health -= dmg_taken
	print("You take " + str(dmg_taken) + " damage! From take_damage function in player script")
	
	if health <= 0:
		death.emit()
	else:
		damage_taken.emit()
