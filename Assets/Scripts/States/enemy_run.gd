extends State
class_name EnemyRun

var from_run: bool = false
var direction
var player
var vel = Vector2()
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var enemy: Node2D = $"../.."

func enter():
	player = get_tree().get_first_node_in_group("Player")
	print("Entering enemy run state")
	animation_player.play("run")

func exit():
	pass

func physics_update(_delta: float):
	direction = player.position - enemy.position
	#vel = Vector2(direction.x, 0) #needs to be tweaked
	#enemy.translate(vel * enemy.SPEED)
	enemy.position.x += direction.x / enemy.SPEED
	#enemy.velocity.x = direction * enemy.SPEED #not working I'm assuming because velocity on Node2D doesnt work
	#check y position and determine whether enemy should jump
	if direction.y < 0: # less than 0 for upwards direction
		enemy.position.y += direction.y / enemy.SPEED


func _on_enemy_damage_taken() -> void:
	from_run = true
	Transition.emit(self, "hurt")

func _on_enemy_death() -> void:
	Transition.emit(self, "death")

func _on_player_tracker_player_escaped() -> void:
	Transition.emit(self, "idle")
