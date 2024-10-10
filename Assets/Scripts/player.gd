extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -310.0

signal damage_taken
signal death

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area_collision_shape: CollisionShape2D = $AttackArea/CollisionShape2D
@onready var jump_particle: GPUParticles2D = $DoubleJumpParticle

# TODO: Some of these can be placed under player class resource
@export var health = 100
@export var damage = 10
@export var attack_area_left: float
@export var attack_area_right: float
@export var no_of_jumps: int = 2

var knockback = Vector2.ZERO
var jumps_left: int
var face_direction_x: int = 1		# -1 = left, 1 = right
var gravity_on: bool = true

func _ready() -> void:
	jumps_left = no_of_jumps

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and gravity_on:
		velocity += get_gravity() * delta

	# direction = -1, 0, 1
	var direction := Input.get_axis("move-left", "move-right")
	
	# Flip sprite direction and attack collision area
	if direction == -1:
		animated_sprite.flip_h = true
		attack_area_collision_shape.position.x = attack_area_left
		face_direction_x = -1
	elif direction == 1:
		animated_sprite.flip_h = false
		attack_area_collision_shape.position.x = attack_area_right
		face_direction_x = 1
	
	move_and_slide()
	knockback = knockback.lerp(Vector2.ZERO, 0.1)

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
		
func take_knockback(body: Node2D, knockback_str: float):
	var direction = body.global_position.direction_to(global_position)
	knockback = direction * knockback_str
	
