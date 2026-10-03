extends Label

var point:int

var speed:float = 0.0

var timer:float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2.ZERO
	create_tween().set_trans(Tween.TRANS_BOUNCE).tween_property(self,"scale",Vector2.ONE,0.5)
	label_settings = LabelSettings.new()
	text = str(point)
	if point >= 5000:
		label_settings.font = load("res://Sprites/scorefont7.png")
		label_settings.font_size = 14
		timer = 2.5
	elif point >= 1000:
		label_settings.font = load("res://Sprites/scorefont6.png")
		label_settings.font_size = 11
		timer = 2.0
	elif point >= 500:
		label_settings.font = load("res://Sprites/scorefont5.png")
		label_settings.font_size = 9
		timer = 1.5
	elif point >= 250:
		label_settings.font = load("res://Sprites/scorefont4.png")
		label_settings.font_size = 8
		timer = 1.25
	elif point >= 100:
		label_settings.font = load("res://Sprites/scorefont3.png")
		label_settings.font_size = 8
		timer = 1.0
	elif point >= 50:
		label_settings.font = load("res://Sprites/scorefont2.png")
		label_settings.font_size = 7
		timer = 0.8
	else:
		label_settings.font = load("res://Sprites/scorefont1.png")
		label_settings.font_size = 7
		timer = 0.6


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	timer -= delta
	if timer < 0:
		if speed < 0.1:
			speed = 50
		speed += 100 * delta
		position.y -= delta * speed
