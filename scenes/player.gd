extends CharacterBody2D

@export var speed = 400
var target = position

func get_input():
	look_at(get_global_mouse_position())
	rotationClamp()
	velocity = transform.x * Input.get_axis("ui_down", "ui_up") * speed

func _input(event):
	# Use is_action_pressed to only accept single taps as input instead of mouse drags.
	if event.is_action_pressed(&"click"):
		target = get_global_mouse_position()
		look_at(target)

func _physics_process(delta):
	velocity = transform.x * speed	
	if position.distance_to(target) > 10:
		move_and_slide()

func rotationClamp():
	if rotation > 45 and rotation < 215:
		rotation = 45
	if rotation > 215:
		scale.x * -1
