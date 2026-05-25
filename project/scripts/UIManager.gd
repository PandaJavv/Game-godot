extends Control

func _ready():
	# Style the UI elements
	_setup_labels()

func _setup_labels():
	# Configure score label style
	var score_label = get_node_or_null("../ScoreLabel")
	var lives_label = get_node_or_null("../LivesLabel")
	var level_label = get_node_or_null("../LevelLabel")
	
	for label in [score_label, lives_label, level_label]:
		if label:
			label.add_theme_font_size_override("font_size", 28)
			label.add_theme_color_override("font_color", Color.WHITE)
			label.add_theme_color_override("font_shadow_color", Color.BLACK)
			label.add_theme_constant_override("shadow_offset_x", 2)
			label.add_theme_constant_override("shadow_offset_y", 2)
