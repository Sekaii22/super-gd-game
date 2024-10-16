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
	direction = enemy.position.direction_to(player.position)
	if direction.x > 0:
		enemy.velocity.x = direction.x * 150
		animated_sprite.flip_h = true #changed for pig enemy since default is face left, thief face right
	elif direction.x < 0:
		enemy.velocity.x = direction.x * 150
		animated_sprite.flip_h = false



func _on_enemy_damage_taken() -> void:
	Transition.emit(self, "hurt")


func _on_enemy_death() -> void:
	Transition.emit(self, "death")


#find a way to reset the timer everytime the attack scene is entered.
#Right now, when re-entering attack, this timer continues and forces idle but the attack continues
func _on_attack_duration_timeout() -> void:
	Transition.emit(self, "idle")
