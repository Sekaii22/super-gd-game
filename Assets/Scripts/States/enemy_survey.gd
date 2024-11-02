extends State
class_name EnemySurvey

#var begin_storing: bool = false
var jump_on_cooldown: bool = false
var direction
var player: CharacterBody2D
@export var player_tracker: RayCast2D
@onready var enemy: CharacterBody2D = $"../.."
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
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
	print("Entering enemy survey state")
	animation_player.play("survey")

func exit():
	enemy.velocity = Vector2(0, 0)

func physics_update(_delta: float):
	print("collision point check " +str(player_tracker.player_collision_point))
	print("Enemy position check " +str(enemy.global_position.x))
	direction = player_tracker.target_position.normalized()
	if abs(enemy.global_position.x - player_tracker.player_collision_point.x) < 16:
		Transition.emit(self, "idle")
	#elif player_tracker.player_close == true:
		#print("raycast to player collision true " +player_tracker.get_collider().name)
		#Transition.emit(self, "alert")
	elif direction.x > 0 and abs(enemy.global_position.x - player_tracker.player_collision_point.x) > 16:
		enemy.velocity.x = direction.x * enemy.SPEED * 0.6
		animated_sprite.flip_h = true #changed for pig enemy since default is face left, thief face right
	elif direction.x < 0 and abs(enemy.global_position.x - player_tracker.player_collision_point.x) > 16:
		enemy.velocity.x = direction.x * enemy.SPEED * 0.6
		animated_sprite.flip_h = false



func _on_enemy_damage_taken() -> void:
	enemy.from_run = true
	Transition.emit(self, "hurt")

func _on_enemy_death() -> void:
	Transition.emit(self, "death")
