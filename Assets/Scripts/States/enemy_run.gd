extends State
class_name EnemyRun

var from_run: bool = false
#var begin_storing: bool = false
var jump_on_cooldown: bool = false
var direction
var player
var enemy: CharacterBody2D
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
#@onready var enemy: CharacterBody2D = $"../.."
@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var jump_cooldown: Timer = $"../../JumpCooldown"


##JUMP VARIABLES
#var velocity := Vector2.ZERO
#@export var jump_height:float
#@export var jump_time_to_peak:float
#@export var jump_time_to_descent:float
#
#@onready var jump_velocity:float = -((2.0*jump_height)/jump_time_to_peak)
#@onready var jump_gravity:float = -((-2.0*jump_height)/(jump_time_to_peak*jump_time_to_peak))
#@onready var fall_gravity:float = -((-2.0*jump_height)/(jump_time_to_descent*jump_time_to_descent))

func enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy = get_tree().get_first_node_in_group("Enemy")
	print("Entering enemy run state")
	animation_player.play("run")
	jump_cooldown.start(2)

func exit():
	enemy.velocity = Vector2(0, 0)

func physics_update(_delta: float):
	direction = enemy.position.direction_to(player.position)
	if direction.x > 0:
		enemy.velocity.x = direction.x * enemy.SPEED
		animated_sprite.flip_h = true #changed for pig enemy since default is face left, thief face right
	elif direction.x < 0:
		enemy.velocity.x = direction.x * enemy.SPEED
		animated_sprite.flip_h = false
	#print("enemy run position " +str(enemy.position))
	#print("Player position " +str(player.position))
	#vel = Vector2(direction.x, 0) #needs to be tweaked
	#enemy.translate(vel * enemy.SPEED)
	#enemy.position.x += direction.x / enemy.SPEED

	#enemy.velocity.x = direction.x * enemy.SPEED
	#print("enemy velocity is " +str(enemy.velocity))
	#print("enemy x direction is " +str(direction.x))  #CHECKS

	#check y position and determine whether enemy should jump
	if direction.y < 0 and enemy.is_on_floor() and jump_on_cooldown == false: # less than 0 for upwards direction
		jump_on_cooldown = true
		jump_cooldown.start()
		print("jump")
		enemy.velocity.y = enemy.JUMP_VELOCITY
	elif abs(snapped(enemy.position.x, 0.01) - snapped(player.position.x, 0.01)) < 16.0:
		print("Attack")
#if it is too close, it won't jump? Or if it is too close, it will jump over the player?
	elif abs(snapped(enemy.position.x, 0.01) - snapped(player.position.x, 0.01)) < 16.0:
		pass
	#elif round(enemy.position.x) == round(player.position.x) and direction.y == 1:
		#enemy.velocity = Vector2(0, 0) #GET OUT OF THE PLAYER'S HEAD, check is working but logic is not
	
#func store_last_direction():
	#if begin_storing == true:
		#var direction2 = player.position - enemy.position
		#begin_storing = false
		#return direction2
		
	

func _on_enemy_damage_taken() -> void:
	from_run = true
	Transition.emit(self, "hurt")

func _on_enemy_death() -> void:
	Transition.emit(self, "death")

func _on_player_tracker_player_escaped() -> void:
	Transition.emit(self, "idle")

func _on_timer_timeout() -> void:
	jump_on_cooldown = false