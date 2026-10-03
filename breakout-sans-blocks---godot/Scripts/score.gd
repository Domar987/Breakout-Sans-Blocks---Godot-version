extends Label

var point:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	point = randi_range(10,7500)
	label_settings = LabelSettings.new()
	text = str(point)
	if point >= 5000:
		label_settings.font = load("res://Sprites/scorefont7.png")
		label_settings.font_size = 14
	elif point >= 1000:
		label_settings.font = load("res://Sprites/scorefont6.png")
		label_settings.font_size = 11
	elif point >= 500:
		label_settings.font = load("res://Sprites/scorefont5.png")
		label_settings.font_size = 9
	elif point >= 250:
		label_settings.font = load("res://Sprites/scorefont4.png")
		label_settings.font_size = 8
	elif point >= 100:
		label_settings.font = load("res://Sprites/scorefont3.png")
		label_settings.font_size = 8
	elif point >= 50:
		label_settings.font = load("res://Sprites/scorefont2.png")
		label_settings.font_size = 7
	else:
		label_settings.font = load("res://Sprites/scorefont1.png")
		label_settings.font_size = 7
	await get_tree().create_timer(1.0).timeout
	_ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
