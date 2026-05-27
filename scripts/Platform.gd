extends StaticBody2D

# Platform - Cosmic Jumper

enum PlatformType { NORMAL, MOVING, BREAKABLE }

var platform_type: PlatformType = PlatformType.NORMAL
var move_range: float = 80.0
var move_speed: float = 60.0
var initial_position: Vector2
var break_timer: float = 0.0
var is_breaking: bool = false

# Color palette for platform types
const COLORS = {
	PlatformType.NORMAL: Color(0.2, 0.9, 0.5, 1),
	PlatformType.MOVING: Color(0.3, 0.6, 1.0, 1),
	PlatformType.BREAKABLE: Color(0.9, 0.5, 0.2, 1),
}

func _ready():
	initial_position = position
	
	# Randomly assign type based on score (handled by randomness)
	var rand = randf()
	if rand < 0.15:
		platform_type = PlatformType.MOVING
	elif rand < 0.25:
		platform_type = PlatformType.BREAKABLE
	
	# Apply color based on type
	$Sprite.color = COLORS[platform_type]

func _physics_process(delta: float):
	match platform_type:
		PlatformType.MOVING:
			_move_platform(delta)
		PlatformType.BREAKABLE:
			if is_breaking:
				_break_platform(delta)

func _move_platform(delta: float):
	var offset = sin(Time.get_ticks_msec() * 0.001 * move_speed * 0.1) * move_range
	position.x = initial_position.x + offset

func _break_platform(delta: float):
	break_timer += delta
	$Sprite.modulate.a = 1.0 - break_timer * 3.0
	if break_timer >= 0.3:
		queue_free()

func on_player_landed():
	if platform_type == PlatformType.BREAKABLE and not is_breaking:
		is_breaking = true
		$CollisionShape2D.disabled = true
