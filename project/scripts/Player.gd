extends CharacterBody2D

# Signals
signal ball_caught(points: int)
signal ball_missed

# Player settings
const SPEED = 600.0
const SCREEN_WIDTH = 480
const PADDLE_HALF_WIDTH = 50

# Touch input state
var touch_id: int = -1
var touch_start_x: float = 0.0
var player_start_x: float = 0.0
var is_touching: bool = false

# Catch area
@onready var catch_area: Area2D = $CatchArea

func _ready():
	# Setup collision shape for the paddle
	var collision = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = Vector2(100, 30)
	collision.shape = rect_shape
	add_child(collision)
	
	# Setup catch area
	_setup_catch_area()

func _setup_catch_area():
	catch_area = Area2D.new()
	var area_collision = CollisionShape2D.new()
	var area_shape = RectangleShape2D.new()
	area_shape.size = Vector2(110, 40)
	area_collision.shape = area_shape
	catch_area.add_child(area_collision)
	add_child(catch_area)
	catch_area.area_entered.connect(_on_catch_area_entered)

func _on_catch_area_entered(area):
	if area.is_in_group("ball"):
		var points = area.get_parent().points
		ball_caught.emit(points)
		area.get_parent().queue_free()

func _input(event):
	# Handle touch input for Android
	if event is InputEventScreenTouch:
		if event.pressed:
			if touch_id == -1:
				touch_id = event.index
				touch_start_x = event.position.x
				player_start_x = position.x
				is_touching = true
		else:
			if event.index == touch_id:
				touch_id = -1
				is_touching = false
	
	elif event is InputEventScreenDrag:
		if event.index == touch_id:
			var delta_x = event.position.x - touch_start_x
			var new_x = player_start_x + delta_x
			position.x = clamp(new_x, PADDLE_HALF_WIDTH, SCREEN_WIDTH - PADDLE_HALF_WIDTH)
	
	# Mouse input for desktop testing
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_touching = true
				touch_start_x = event.position.x
				player_start_x = position.x
			else:
				is_touching = false
	
	elif event is InputEventMouseMotion:
		if is_touching:
			var delta_x = event.position.x - touch_start_x
			var new_x = player_start_x + delta_x
			position.x = clamp(new_x, PADDLE_HALF_WIDTH, SCREEN_WIDTH - PADDLE_HALF_WIDTH)

func _physics_process(_delta):
	# Keyboard controls for desktop testing
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	elif Input.is_action_pressed("ui_right"):
		direction = 1
	
	if direction != 0:
		velocity.x = direction * SPEED
		move_and_slide()
		position.x = clamp(position.x, PADDLE_HALF_WIDTH, SCREEN_WIDTH - PADDLE_HALF_WIDTH)
