extends CharacterBody2D

# Player Controller - Cosmic Jumper

const JUMP_FORCE = -700.0
const GRAVITY = 1200.0
const MOVE_SPEED = 320.0
const SCREEN_WIDTH = 480.0

var is_jumping: bool = false
var touch_start_x: float = -1.0
var swipe_sensitivity: float = 1.5

func _ready():
	velocity.y = JUMP_FORCE * 0.5  # Initial small jump

func _physics_process(delta: float):
	# Apply gravity
	velocity.y += GRAVITY * delta
	
	# Handle touch/tilt input for horizontal movement
	_handle_input(delta)
	
	# Move and collide
	move_and_slide()
	
	# Jump when landing on platform
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_normal().y < -0.5:  # Floor collision
			velocity.y = JUMP_FORCE
			_play_jump_effect()
	
	# Screen wrap horizontally
	if position.x < -20:
		position.x = SCREEN_WIDTH + 20
	elif position.x > SCREEN_WIDTH + 20:
		position.x = -20
	
	# Tilt sprite based on horizontal velocity
	if velocity.x != 0:
		$Sprite.skew = clamp(velocity.x / MOVE_SPEED * 0.2, -0.3, 0.3)

func _handle_input(_delta: float):
	# Accelerometer input (tilt)
	if Input.is_action_pressed("ui_left"):
		velocity.x = -MOVE_SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x = MOVE_SPEED
	else:
		# Use accelerometer on mobile
		var accel = Input.get_accelerometer()
		if accel.length() > 0.1:
			velocity.x = clamp(-accel.x * 150.0, -MOVE_SPEED, MOVE_SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, MOVE_SPEED * 0.15)

func _input(event: InputEvent):
	# Touch swipe for horizontal movement
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_start_x = event.position.x
		else:
			touch_start_x = -1.0
	
	if event is InputEventScreenDrag:
		var dx = event.relative.x * swipe_sensitivity
		velocity.x = clamp(dx * 60.0, -MOVE_SPEED, MOVE_SPEED)

func _play_jump_effect():
	# Visual squash/stretch on jump
	var tween = create_tween()
	tween.tween_property($Sprite, "scale", Vector2(1.3, 0.7), 0.05)
	tween.tween_property($Sprite, "scale", Vector2(0.85, 1.2), 0.08)
	tween.tween_property($Sprite, "scale", Vector2(1.0, 1.0), 0.1)
