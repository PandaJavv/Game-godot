extends RigidBody2D

# Signals
signal ball_missed

# Ball properties
var speed: float = 200.0
var points: int = 1
var ball_color: Color = Color.WHITE

# Ball types with different colors and points
const BALL_TYPES = [
	{"color": Color(1, 0.3, 0.3), "points": 1, "size": 20},   # Red - common
	{"color": Color(0.3, 0.7, 1), "points": 2, "size": 18},    # Blue - uncommon
	{"color": Color(1, 0.8, 0.2), "points": 3, "size": 15},    # Gold - rare
	{"color": Color(0.8, 0.3, 1), "points": 5, "size": 12},    # Purple - very rare
]

@onready var sprite: ColorRect = $Sprite
@onready var catch_area: Area2D = $Area2D

func _ready():
	# Random ball type weighted by rarity
	var rand = randf()
	var ball_type
	if rand < 0.5:
		ball_type = BALL_TYPES[0]
	elif rand < 0.75:
		ball_type = BALL_TYPES[1]
	elif rand < 0.9:
		ball_type = BALL_TYPES[2]
	else:
		ball_type = BALL_TYPES[3]
	
	points = ball_type.points
	ball_color = ball_type.color
	var size = ball_type.size
	
	# Setup visual
	sprite.color = ball_color
	sprite.size = Vector2(size * 2, size * 2)
	sprite.position = Vector2(-size, -size)
	
	# Setup physics - no gravity, manual movement
	gravity_scale = 0
	freeze = true  # We'll move it manually
	
	# Add to ball group for detection
	add_to_group("falling_ball")
	
	# Setup collision area
	var area = $Area2D
	var col_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = size
	col_shape.shape = circle
	area.add_child(col_shape)
	area.add_to_group("ball")

func _process(delta):
	# Move ball downward
	position.y += speed * delta
	
	# Add slight wobble for visual interest
	position.x += sin(Time.get_ticks_msec() * 0.003 + position.y * 0.01) * 0.5
	
	# Check if ball went off screen (missed)
	if position.y > 900:
		ball_missed.emit()
		queue_free()

func _draw():
	# Draw ball as circle
	draw_circle(Vector2.ZERO, 15, ball_color)
	# Draw highlight
	draw_circle(Vector2(-4, -4), 5, Color(1, 1, 1, 0.4))
