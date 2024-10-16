extends State
class_name EnemyAttack

var from_run: bool = false
var attack_is_charging: bool = true
var direction
var player
@onready var enemy: CharacterBody2D = $"../.."
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var charge_attack: Timer = $"../../ChargeAttack"
@onready var attack_area: CollisionShape2D = $"../../AttackRange/CollisionShape2D"
@onready var attack_duration: Timer = $"../../AttackDuration"
@onready var exhaust_reset: Timer = $"../../ExhaustReset"



func enter():
	player = get_tree().get_first_node_in_group("Player")
	print("Entering enemy attack state")
	animation_player.play("attack")
	charge_attack.start()

func exit():
	attack_area.set_deferred("disabled", true)
	enemy.exhausted = true
	exhaust_reset.start()
	enemy.velocity = Vector2(0, 0)

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func _on_charge_attack_timeout() -> void:
	attack_duration.start()
	attack_area.disabled = false
	animation_player.play("run")
	direction = enemy.global_position.direction_to(player.global_position)
	if direction.x > 0:
		enemy.velocity.x = direction.x * 150
		animated_sprite.flip_h = true #changed for pig enemy since default is face left, thief face right
	elif direction.x < 0:
		enemy.velocity.x = direction.x * 150
		animated_sprite.flip_h = false


#I want to continue attack after escaping raycast? Should I?


func _on_enemy_damage_taken() -> void:
	attack_duration.stop()
	Transition.emit(self, "hurt")


func _on_enemy_death() -> void:
	Transition.emit(self, "death")


func _on_attack_duration_timeout() -> void:
	Transition.emit(self, "idle")
