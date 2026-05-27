extends Node2D

# Cosmic Jumper - Main Game Controller

const PLATFORM_SCENE = preload("res://scenes/Platform.tscn")
const SCREEN_WIDTH = 480
const SCREEN_HEIGHT = 854
const PLATFORM_COUNT = 10
const PLATFORM_SPACING = 100
const SCROLL_SPEED_BASE = 2.0

var score: int = 0
var highest_score: int = 0
var camera_target_y: float = 0.0
var scroll_speed: float = SCROLL_SPEED_BASE
var game_active: bool = true
var platforms: Array = []

@onready var player = $Player
@onready var camera = $Camera2D
@onready var score_label = $UI/ScoreLabel
@onready var game_over_panel = $UI/GameOverPanel
@onready var final_score_label = $UI/GameOverPanel/FinalScoreLabel
@onready var restart_button = $UI/GameOverPanel/RestartButton
@onready var platforms_node = $Platforms

func _ready():
	_generate_initial_platforms()
	camera_target_y = player.position.y - SCREEN_HEIGHT * 0.4
	camera.position.y = camera_target_y
	restart_button.pressed.connect(_on_restart_pressed)
	
	# Load highest score
	if FileAccess.file_exists("user://save.dat"):
		var f = FileAccess.open("user://save.dat", FileAccess.READ)
		highest_score = f.get_32()
		f.close()

func _generate_initial_platforms():
	# Starting platform under player
	var start_platform = PLATFORM_SCENE.instantiate()
	start_platform.position = Vector2(240, 730)
	platforms_node.add_child(start_platform)
	platforms.append(start_platform)
	
	# Generate platforms upward
	for i in range(1, PLATFORM_COUNT):
		_spawn_platform_at(Vector2(
			randf_range(60, SCREEN_WIDTH - 60),
			730 - i * PLATFORM_SPACING
		))

func _spawn_platform_at(pos: Vector2):
	var platform = PLATFORM_SCENE.instantiate()
	platform.position = pos
	platforms_node.add_child(platform)
	platforms.append(platform)

func _process(delta: float):
	if not game_active:
		return
	
	# Follow player upward (camera only moves up)
	var target_y = player.position.y - SCREEN_HEIGHT * 0.4
	if target_y < camera_target_y:
		camera_target_y = target_y
	camera.position.y = lerp(camera.position.y, camera_target_y, 0.1)
	
	# Update score based on height
	var new_score = int((730 - player.position.y) / 10)
	if new_score > score:
		score = new_score
		score_label.text = "Score: %d" % score
		# Increase difficulty
		scroll_speed = SCROLL_SPEED_BASE + score * 0.01
	
	# Recycle platforms that are below screen
	var camera_bottom = camera.position.y + SCREEN_HEIGHT * 0.6
	var camera_top = camera.position.y - SCREEN_HEIGHT * 0.6
	
	for platform in platforms:
		if platform.position.y > camera_bottom + 50:
			# Recycle to top
			platform.position = Vector2(
				randf_range(60, SCREEN_WIDTH - 60),
				camera_top - randf_range(50, 120)
			)
	
	# Check if player fell below screen
	if player.position.y > camera.position.y + SCREEN_HEIGHT * 0.6:
		_game_over()

func _game_over():
	game_active = false
	player.set_process(false)
	
	if score > highest_score:
		highest_score = score
		var f = FileAccess.open("user://save.dat", FileAccess.WRITE)
		f.store_32(highest_score)
		f.close()
	
	final_score_label.text = "Score: %d\nBest: %d" % [score, highest_score]
	game_over_panel.visible = true

func _on_restart_pressed():
	get_tree().reload_current_scene()
