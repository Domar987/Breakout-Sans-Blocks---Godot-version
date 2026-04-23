extends EdgeBorder

var animtimer = 30 * (Engine.get_frames_per_second() / 60)

func _ready() -> void:
	var leftportaltexture = load("res://Sprites/leftportal.png")
	var rightportaltexture = load("res://Sprites/rightportal.png")
	lefttexture = []
	righttexture = []
	wallwidth = 12
	wallheight = 10
	var texwidth = leftportaltexture.get_width() / 4
	var texheight = leftportaltexture.get_height()
	for i in range(0,3):
		var atlas = AtlasTexture.new()
		atlas.atlas = leftportaltexture
		atlas.region = Rect2(texwidth * i, 0, texwidth, texheight)
		lefttexture.append(atlas)
	for i in range(0,3):
		var atlas = AtlasTexture.new()
		atlas.atlas = rightportaltexture
		atlas.region = Rect2(texwidth * i, 0, texwidth, texheight)
		righttexture.append(atlas)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	animtimer -= 1
	if animtimer <= 0:
		animtimer = 30 * (Engine.get_frames_per_second() / 60)
		lefttexture.insert(0, lefttexture[-1])
		righttexture.insert(0, righttexture[-1])
		lefttexture.pop_back()
		righttexture.pop_back()
		queue_redraw()
	super(_delta)

func _draw() -> void:
	if not RuleManager.walls:
		super()
