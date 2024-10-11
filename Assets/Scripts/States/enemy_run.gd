extends State
class_name EnemyRun

var from_run: bool = false
var begin_storing: bool = false
var direction
var player
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var enemy: CharacterBody2D = $"../.."
@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"


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
	print("Entering enemy run state")
	animation_player.play("run")
	enemy.velocity.x = 1 * enemy.SPEED

func exit():
	pass

func physics_update(_delta: float):
	direction = player.position - enemy.position
	if direction.x > 0:
		enemy.velocity.x = direction.x * enemy.SPEED
		animated_sprite.flip_h = false
	elif direction.x < 0:
		enemy.velocity.x = -direction.x * enemy.SPEED
		animated_sprite.flip_h = true
	#print("enemy run position" +str(enemy.position))
	#vel = Vector2(direction.x, 0) #needs to be tweaked
	#enemy.translate(vel * enemy.SPEED)
	#enemy.position.x += direction.x / enemy.SPEED

	#enemy.velocity.x = direction.x * enemy.SPEED
	print("enemy velocity is " +str(enemy.velocity))
	print("enemy x direction is " +str(direction.x))
	print("enemy y position is " +str(enemy.position.y))

	#check y position and determine whether enemy should jump
	if direction.y < 0: # less than 0 for upwards direction
		print("jump")
		enemy.velocity.y = enemy.JUMP_VELOCITY
	
func store_last_direction():
	if begin_storing == true:
		var direction2 = player.position - enemy.position
		begin_storing = false
		return direction2
		
	

func _on_enemy_damage_taken() -> void:
	from_run = true
	Transition.emit(self, "hurt")

func _on_enemy_death() -> void:
	Transition.emit(self, "death")

func _on_player_tracker_player_escaped() -> void:
	Transition.emit(self, "idle")
