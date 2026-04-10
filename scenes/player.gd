extends CharacterBody2D

@export var speed = 400
@export var max_rotation_degrees := 45.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var target = position

func _input(event):
	# Use is_action_pressed to only accept single taps as input instead of mouse drags.
	if event.is_action_pressed(&"click"):
		target = get_global_mouse_position()
		var mouse_pos = get_global_mouse_position()
		var dir = mouse_pos - global_position
	
	# Angle to target in radians
		var angle_deg = rad_to_deg(dir.angle())
		var facing_left = dir.x < 0
	
		sprite.flip_h = facing_left
	
		if facing_left:
			angle_deg = 180.0 + angle_deg
	
	
	# Normalize to a clean -180 to 180 range
		angle_deg = wrapf(angle_deg, -180.0, 180.0)
	
	# Clamp tilt so it only rotates between -45 and +45
		angle_deg = clamp(angle_deg, -max_rotation_degrees, max_rotation_degrees)
	
		sprite.rotation_degrees = angle_deg
		velocity = position.direction_to(target) * speed

func _physics_process(delta):
	if position.distance_to(target) > 10:
		move_and_slide()
