extends CharacterBody2D

@export var speed = 200
@export var max_rotation_degrees := 45.0
@export var health = 3
@export var collisionDriftDuration = 1
@export var sonar_interval = 5 #how many seconds to wait after the last ping ends
@export var sonar_duration = 3 #how many seconds a sonar ping lasts
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var SonarIntervalTimer = $TimerSonarInterval
@onready var SonarDurationTimer = $TimerSonarDuration
var target = position

func _ready():
	SonarIntervalTimer.one_shot = true
	SonarDurationTimer.one_shot = true
	$PointLight2D.enabled = false

func _input(event):
	# Use is_action_pressed to only accept single taps as input instead of mouse drags.
	if event.is_action_pressed(&"click"):
		movement()
	elif event.is_action_pressed(&"space"):
		sonar()
		
func movement(): 
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
 
func sonar():
	if SonarIntervalTimer.time_left <= 0:
		SonarDurationTimer.start(sonar_duration)
		$PointLight2D.enabled = true    
		$AudioPlayerSonar.play()
		SonarIntervalTimer.start(sonar_duration + sonar_interval)
	else:
		print(SonarIntervalTimer.time_left)

func _physics_process(_delta):
	if position.distance_to(target) > 10:
		move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		health -= 1;
		#if(health <= 0):
		#	free()
		print(health)
		velocity = velocity * -0.2
		await get_tree().create_timer(collisionDriftDuration).timeout
		velocity = velocity * 0



func _on_body_entered(_body):
	health -= 1;
	$AudioPlayerDamage.play()
	print(health)

func _on_timer_sonar_duration_timeout() -> void:
	$PointLight2D.enabled = false
	print("turn off light")


func _on_timer_sonar_interval_timeout() -> void:
	$AudioPlayerRecharge.play()
