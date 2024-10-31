extends TextureButton
class_name SkillButton

signal cooldown_timer_timeout

@onready var cooldown_progress_bar: TextureProgressBar = $CooldownProgressBar
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var cooldown_label: Label = $CooldownLabel

@export var cooldown_time: float = 1.0

var is_on_cooldown: bool = false


func _ready() -> void:
	cooldown_timer.wait_time = cooldown_time
	cooldown_label.text = ""


func _process(_delta: float) -> void:
	cooldown_progress_bar.value = cooldown_timer.time_left
	
	if !cooldown_timer.is_stopped():
		cooldown_label.text = "%3.1f" % cooldown_timer.time_left


## Signal Handlers
func _on_pressed() -> void:
	is_on_cooldown = true
	cooldown_progress_bar.max_value = cooldown_timer.wait_time
	cooldown_timer.start()


func _on_cooldown_timer_timeout() -> void:
	# TODO: Add animation or effects
	is_on_cooldown = false
	cooldown_progress_bar.value = 0
	cooldown_label.text = ""
	cooldown_timer_timeout.emit()
