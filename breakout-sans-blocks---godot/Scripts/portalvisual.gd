extends EdgeBorder

var animtimer:float = 0.2

var oldAddition:float = 0

func _ready() -> void:
	var leftportaltexture = load("res://Sprites/leftportal.png")
	var rightportaltexture = load("res://Sprites/rightportal.png")
	lefttexture = []
	righttexture = []
	wallwidth = 12
	wallheight = 10
	var texwidth = leftportaltexture.get_width() / 4
	var texheight = leftportaltexture.get_height()
	for i in range(0,4):
		var atlas = AtlasTexture.new()
		atlas.atlas = leftportaltexture
		atlas.region = Rect2(texwidth * i, 0, texwidth, texheight)
		lefttexture.append(atlas)
	for i in range(0,4):
		var atlas = AtlasTexture.new()
		atlas.atlas = rightportaltexture
		atlas.region = Rect2(texwidth * i, 0, texwidth, texheight)
		righttexture.append(atlas)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	animtimer -= delta
	if animtimer <= 0:
		animtimer = 0.2
		frame()
		if RuleManager.ySpeed == 0 and RuleManager.zoom == oldzoom:
			queue_redraw()
	super(delta)
	if oldAddition > ySpeedAddition:
		frame()
		queue_redraw()
	oldAddition = ySpeedAddition

func _draw() -> void:
	if not RuleManager.walls:
		super()

func drawfuncfunc(i:int,x:float,y:float)->void:
	drawfunc(i%len(lefttexture),x,y)

func frame()->void:
	lefttexture.insert(0, lefttexture[-1])
	righttexture.insert(0, righttexture[-1])
	lefttexture.pop_back()
	righttexture.pop_back()
