extends Node

var font

func _ready() -> void:
	font = load("res://Assets/Fonts/m5x7.ttf")

func display_number(value: int, position: Vector2, is_critical: bool = false):
	# Creating damage number label
	var number_label = Label.new()
	number_label.position = position
	number_label.position.x += randi_range(-3, 3)
	number_label.text = str(value)
	number_label.z_index = 10
	number_label.label_settings = LabelSettings.new()
	
	var color: Color = Color("#FFFFFF")
	if is_critical:
		color = Color("#BB2222")
	if value == 0:
		color = Color("#FFFFFF", 0.5)
	
	# Set label font settings
	number_label.label_settings.font = font
	number_label.label_settings.font_color = color
	number_label.label_settings.font_size = 32
	number_label.label_settings.outline_color = Color("#000000")
	number_label.label_settings.outline_size = 2
	
	# Add label as child
	call_deferred("add_child", number_label)
	await number_label.resized
	number_label.pivot_offset = Vector2(number_label.size / 2)
	
	# Setup animation of damage numbers
	var tween = get_tree().create_tween()
	var rand_offset = randi_range(0, 10)
	
	# Moves up and down
	tween.tween_property(number_label, "position:y", \
		number_label.position.y - 30 - rand_offset, 0.25).set_ease(Tween.EASE_OUT)
	tween.tween_property(number_label, "position:y", \
		number_label.position.y - 15 - rand_offset, 0.5).set_ease(Tween.EASE_IN)
	# set_parallel allows diff properties to be tween at the same time
	tween.set_parallel()
	# Reduce scale and opacity when moving downwards
	tween.tween_property(number_label, "scale", \
		Vector2.ZERO, 0.25).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(number_label, "self_modulate:a", 
		0.0, 0.25).set_delay(0.25)
		
	await tween.finished
	number_label.queue_free()
