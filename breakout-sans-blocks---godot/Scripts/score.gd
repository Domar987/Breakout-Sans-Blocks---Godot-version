extends Label

var point:int

var speed:float = 0.0

var timer:float = 3.0
@onready var RuleManager = $/root/Ingame/RuleManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position -= Vector2.ONE * 32
	var tmp = 960/(2*RuleManager.zoom) - 32
	if position.x + 32 < -tmp:
		create_tween().tween_property(self,"position",Vector2(-tmp - 32,position.y),0.3)
	elif position.x + 32 > tmp:
		create_tween().tween_property(self,"position",Vector2(tmp - 32,position.y),0.3)
	if point == 0:
		queue_free()
	scale = Vector2.ZERO
	create_tween().set_trans(Tween.TRANS_BOUNCE).tween_property(self,"scale",Vector2.ONE,0.5)
	label_settings = LabelSettings.new()
	text = str(point)
	pointSetting()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	timer -= delta
	if timer < 0:
		if speed < 0.1:
			speed = 50
		speed += 100 * delta
		position.y -= delta * speed

func pointSetting()->void:
	if point >= 5000:
		setting(7,14,2.5)
	elif point >= 1000:
		setting(6,11,2.0)
	elif point >= 500:
		setting(5,9,1.5)
	elif point >= 250:
		setting(4,8,1.25)
	elif point >= 100:
		setting(3,8,1.0)
	elif point >= 50:
		setting(2,7,0.8)
	else:
		setting(1,7,0.6)

func setting(index:int,size:int,duration:float)->void:
	label_settings.font = load("res://Sprites/scorefont"+str(index)+".png")
	label_settings.font_size = size
	timer = duration
