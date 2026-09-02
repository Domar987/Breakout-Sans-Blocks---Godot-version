extends EdgeBorder

var colShape1 = WorldBoundaryShape2D.new()
var colShape2 = WorldBoundaryShape2D.new()

@onready var background =  $/root/Ingame/Background

var bgfile = FileAccess.get_file_as_string("res://Data/wall_colors.json")
var bgcolors = JSON.parse_string(bgfile)

var currentcolors:Array

func _ready() -> void:
	lefttexture = [Animator.applyColor("res://Sprites/wallleft.png",bgcolors[0])]
	righttexture = [Animator.applyColor("res://Sprites/wallright.png",bgcolors[0])]
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
	lefttexture[0] = Animator.applyColor("res://Sprites/wallleft.png",currentcolors)
	righttexture[0] = Animator.applyColor("res://Sprites/wallright.png",currentcolors)

func _draw() -> void:
	if RuleManager.walls:
		super()

func drawfuncfunc(i:int,x:float,y:float)->void:
	drawfunc(0,x,y)
