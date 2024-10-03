extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var health = 100

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# direction = -1, 0, 1
	var direction := Input.get_axis("move-left", "move-right")
	
	# Flip direction
	if direction == -1:
		animated_sprite.flip_h = true
	elif direction == 1:
		animated_sprite.flip_h = false
	
	# Animation
	if animation_player.current_animation == "attack" and animation_player.is_playing():
		if is_on_floor():
			velocity.x = 0
	else:
		if is_on_floor():
			if direction == 0:
				animation_player.play("idle")
			else:
				animation_player.play("run")
		else:
			animation_player.play("jump")
			#Jump animation is temporary
			
		# Movement
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
	if Input.is_action_just_pressed("attack"):
		animation_player.play("attack")
	
	move_and_slide()
