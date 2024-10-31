extends CharacterBody2D
class_name Player

const SPEED = 150.0
const JUMP_VELOCITY = -360.0

signal DamageTaken
signal Death
signal Special1_Casted
signal Special2_Casted

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area_collision_shape: CollisionShape2D = $AttackArea/CollisionShape2D
@onready var coyote_timer: Timer = $CoyoteTimer					# Gives small window to execute jump after falling in run state
@onready var dash_reset_timer: Timer = $DashResetTimer
@onready var attack_grace_timer: Timer = $AttackGraceTimer		# Gives small window to continue attack chain after an attack animation is finished

# TODO: Some of these can be placed under player class resource
@export var health = 100
@export var no_of_jumps: int = 2
@export var no_of_dashes: int = 1

@export_category("Attacks")
## key = string, value = AttackResource
@export var damage_resources : Dictionary
@export var no_of_basic_atks: int = 1
@export var skill1_button: SkillButton
@export var skill2_button: SkillButton

@export_group("Animation Purpose Only")
@export var attack_area_pos: Vector2		## Not for editing
@export var attack_area_rotation: float		## Not for editing

## GET only
var current_damage: DamageResource
var knockback = Vector2.ZERO
var face_direction_x: int = 1		# -1 = left, 1 = right
var in_coyote_time: bool = false

## GET and SET
var jumps_left: int
var dashes_left: int
var gravity_on: bool = true
var current_atk_seq: int = 0
var lock_direction: bool = false


func _ready() -> void:
	Global.player = self
	jumps_left = no_of_jumps
	dashes_left = no_of_dashes


# Used for graphical updates
func _process(_delta: float) -> void:
	# direction = -1, 0, 1
	var direction := Input.get_axis("move-left", "move-right")
	
	# Flip sprite direction and attack collision area
	if direction == -1 and lock_direction == false:
		animated_sprite.flip_h = true
		face_direction_x = -1
	elif direction == 1 and lock_direction == false:
		animated_sprite.flip_h = false
		face_direction_x = 1
	set_attack_collision_position()
	
	# Only start dash reset timer when at least 1 dash is consumed
	# and dash reset time is not started alr
	if dashes_left != no_of_dashes and dash_reset_timer.is_stopped():
		dash_reset_timer.start()
		
	check_for_special_cast()


# Used for physics updates
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and gravity_on:
		velocity += get_gravity() * delta
	
	# Used in coyote time
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
		in_coyote_time = true
	
	# Reduce knockback overtime
	#knockback = knockback.lerp(Vector2.ZERO, 0.1)
	knockback.x = lerp(knockback.x, 0.0, 0.1)


# Call this method when you want the player to take damage
func take_damage(dmg_taken: int, timescale_duration = 0.7):
	health -= dmg_taken
	print("You take " + str(dmg_taken) + " damage! From take_damage function in player script")
	
	if health <= 0:
		Death.emit()
	else:
		DamageTaken.emit()
	
	# Adjust timescale for more impact, duration < 0.8 is almost unnoticable
	Engine.time_scale = 0.01
	await get_tree().create_timer(timescale_duration * 0.01).timeout
	Engine.time_scale = 1
	

# Call this method when you want to give player some knockback
func take_knockback(body: Node2D, knockback_x_str: float = 150.0, \
	knockback_y_str: float = 150.0):
	var direction = body.global_position.direction_to(global_position)
	if direction.x < 0:
		knockback.x = -1 * knockback_x_str
	else:
		knockback.x = 1 * knockback_x_str
	
	knockback.y = -1 * knockback_y_str


# Returns a boolean indicating if player is able to jump
func can_jump() -> bool:
	if jumps_left > 0:
		return true
	else:
		return false


# Returns a boolean indicating if player is able to dash
func can_dash() -> bool:
	if dashes_left > 0:
		return true
	else:
		return false


# Set the position for the attack collision shape
func set_attack_collision_position():
	if face_direction_x == -1:
		attack_area_collision_shape.position.x = -attack_area_pos.x
		attack_area_collision_shape.rotation = -attack_area_rotation
	else:
		attack_area_collision_shape.position.x = attack_area_pos.x
		attack_area_collision_shape.rotation = attack_area_rotation
	attack_area_collision_shape.position.y = attack_area_pos.y


# Switch current attack, used in animation
func switch_damage(key: String):
	current_damage = damage_resources[key]


func check_for_special_cast():
	if Input.is_action_just_pressed("skill1"):
		if !skill1_button.is_on_cooldown:
			Special1_Casted.emit()
		else:
			print("Skill 1 on cooldown")
		
	elif Input.is_action_just_pressed("skill2"):
		if !skill2_button.is_on_cooldown:
			Special2_Casted.emit()
		else:
			print("skill 2 on cooldown")


## Signal Handlers
func _on_dash_reset_timer_timeout() -> void:
	dashes_left = no_of_dashes


func _on_coyote_timer_timeout() -> void:
	in_coyote_time = false


func _on_attack_grace_timer_timeout() -> void:
	current_atk_seq = 0


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	# Starts attack reset timer after an attack animation has ended
	if anim_name.begins_with("attack"):
		attack_grace_timer.start()


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	# Stop attack reset timer when an attack animation starts to prevent
	# resetting attacks in the middle of the next attack animation
	if anim_name.begins_with("attack"):
		attack_grace_timer.stop()


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.name.containsn("Enemy"):
		print(body.name + " has taken " + str(current_damage.damage) + " " \
		+ current_damage.type + " damage!")
		body.take_damage(current_damage.damage)
