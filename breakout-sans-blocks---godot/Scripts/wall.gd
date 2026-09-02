extends EdgeBorder

var colShape1 = WorldBoundaryShape2D.new()
var colShape2 = WorldBoundaryShape2D.new()

@onready var background =  $/root/Ingame/Background

var bgfile = FileAccess.get_file_as_string("res://Data/wall_colors.json")
var bgcolors = JSON.parse_string(bgfile)

var currentcolors:Array

func _ready() -> void:
	var ltmp = Animator.applyColor("res://Sprites/wallleft.png",bgcolors[0])
	var rtmp = Animator.applyColor("res://Sprites/wallright.png",bgcolors[0])
	lefttexture = [ltmp,ltmp]
	righttexture = [rtmp,rtmp]
	wallwidth = 12
	wallheight = 10
	colShape1.normal = Vector2(1,0)
	colShape2.normal = Vector2(-1,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	colShape1.distance = -960/(2*RuleManager.zoom) + wallwidth
	colShape2.distance = -960/(2*RuleManager.zoom) + wallwidth
	$CollisionShape2D1.shape = colShape1
	$CollisionShape2D2.shape = colShape2
	super(_delta)

func updateColor()->void:
	currentcolors = bgcolors[background.level]
	lefttexture.insert(0, Animator.applyColor("res://Sprites/wallleft.png",currentcolors))
	righttexture.insert(0, Animator.applyColor("res://Sprites/wallright.png",currentcolors))
	lefttexture.pop_back()
	righttexture.pop_back()

func _draw() -> void:
	if RuleManager.walls:
		super()

func drawfuncfunc(i:int,x:float,y:float)->void:
	if background.drawtrans:
		var tmp = (background.yvalue - background.startY + background.transheight)/(4*RuleManager.zoom)
		tmp = int(tmp)
		if i > tmp:
			drawfunc(1,x,y)
		else:
			drawfunc(0,x,y)
	else:
		drawfunc(0,x,y)
