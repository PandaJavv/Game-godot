extends Node2D

# Game constants
const BALL_SCENE_PATH = "res://scenes/Ball.tscn"
const INITIAL_SPAWN_INTERVAL = 1.5
const MIN_SPAWN_INTERVAL = 0.4
const LEVEL_UP_SCORE = 10

# Game state
var score: int = 0
var lives: int = 3
var level: int = 1
var is_game_over: bool = false
var high_score: int = 0

# Node references
@onready var ball_container = $GameArea/BallContainer
@onready var ball_spawner = $GameArea/BallSpawner
@onready var player = $GameArea/Player
@onready var ui = $UILayer/UI
@onready var score_label = $UILayer/UI/ScoreLabel
@onready var lives_label = $UILayer/UI/LivesLabel
@onready var level_label = $UILayer/UI/LevelLabel
@onready var game_over_panel = $UILayer/UI/GameOverPanel
@onready var final_score_label = $UILayer/UI/GameOverPanel/FinalScoreLabel
@onready var restart_button = $UILayer/UI/GameOverPanel/RestartButton

func _ready():
	# Load high score from saved data
	high_score = _load_high_score()
	
	# Connect signals
	ball_spawner.timeout.connect(_spawn_ball)
	restart_button.pressed.connect(_restart_game)
	player.ball_caught.connect(_on_ball_caught)
	player.ball_missed.connect(_on_ball_missed)
	
	# Start game
	_update_ui()

func _spawn_ball():
	if is_game_over:
		return
	
	# Load and instance ball scene
	var ball_scene = load(BALL_SCENE_PATH)
	if ball_scene:
		var ball = ball_scene.instantiate()
		ball_container.add_child(ball)
		
		# Random horizontal position
		var spawn_x = randf_range(30, 450)
		ball.position = Vector2(spawn_x, -30)
		
		# Increase speed based on level
		ball.speed = 200 + (level * 50)
		ball.ball_missed.connect(_on_ball_missed)

func _on_ball_caught(points: int):
	score += points
	_update_ui()
	
	# Level up check
	if score >= level * LEVEL_UP_SCORE:
		_level_up()

func _on_ball_missed():
	lives -= 1
	_update_ui()
	
	# Screen shake effect
	_screen_shake()
	
	if lives <= 0:
		_game_over()

func _level_up():
	level += 1
	level_label.text = "Level: " + str(level)
	
	# Increase spawn rate (decrease interval)
	var new_interval = max(MIN_SPAWN_INTERVAL, INITIAL_SPAWN_INTERVAL - (level * 0.15))
	ball_spawner.wait_time = new_interval
	
	# Visual feedback for level up
	_show_level_up_effect()

func _game_over():
	is_game_over = true
	ball_spawner.stop()
	
	# Save high score
	if score > high_score:
		high_score = score
		_save_high_score()
	
	# Show game over panel
	final_score_label.text = "Score: " + str(score) + "\nBest: " + str(high_score)
	game_over_panel.visible = true

func _restart_game():
	# Reset state
	score = 0
	lives = 3
	level = 1
	is_game_over = false
	
	# Clear all balls
	for ball in ball_container.get_children():
		ball.queue_free()
	
	# Reset spawner
	ball_spawner.wait_time = INITIAL_SPAWN_INTERVAL
	ball_spawner.start()
	
	# Reset player position
	player.position = Vector2(240, 780)
	
	# Hide game over panel
	game_over_panel.visible = false
	
	_update_ui()

func _update_ui():
	score_label.text = "Score: " + str(score)
	lives_label.text = "Lives: " + str(lives)
	level_label.text = "Level: " + str(level)

func _screen_shake():
	var tween = create_tween()
	var original_pos = Vector2.ZERO
	tween.tween_property(self, "position", Vector2(10, 0), 0.05)
	tween.tween_property(self, "position", Vector2(-10, 0), 0.05)
	tween.tween_property(self, "position", Vector2(5, 0), 0.05)
	tween.tween_property(self, "position", original_pos, 0.05)

func _show_level_up_effect():
	# Create a temporary label for level up notification
	var label = Label.new()
	label.text = "LEVEL UP!"
	label.position = Vector2(240, 400)
	label.add_theme_font_size_override("font_size", 48)
	add_child(label)
	
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 1.5)
	tween.tween_callback(label.queue_free)

func _save_high_score():
	var config = ConfigFile.new()
	config.set_value("game", "high_score", high_score)
	config.save("user://save_data.cfg")

func _load_high_score() -> int:
	var config = ConfigFile.new()
	var err = config.load("user://save_data.cfg")
	if err == OK:
		return config.get_value("game", "high_score", 0)
	return 0
