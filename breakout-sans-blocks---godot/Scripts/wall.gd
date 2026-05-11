extends EdgeBorder

var colShape1 = WorldBoundaryShape2D.new()
var colShape2 = WorldBoundaryShape2D.new()

@onready var background =  $/root/Ingame/Background

var oldy:float

var bgfile = FileAccess.get_file_as_string("res://Data/wall_colors.json")
var bgcolors = JSON.parse_string(bgfile)

var currentcolors:Array

func _ready() -> void:
	lefttexture = [Animator.new().applyColor("res://Sprites/wallleft.png",bgcolors[0])]
	righttexture = [Animator.new().applyColor("res://Sprites/wallright.png",bgcolors[0])]
	wallwidth = 12
	wallheight = 10
	colShape1.normal = Vector2(1,0)
	colShape2.normal = Vector2(-1,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	colShape1.distance = -960/(2*RuleManager.zoom) + wallwidth
	colShape2.distance = -960/(2*RuleManager.zoom) + wallwidth
	$CollisionShape2D1.shape = colShape1
	$CollisionShape2D2.shape = colShape2
	if oldy != background.yvalue:
		currentcolors = bgcolors[min(int(background.yvalue/(1000)),len(bgcolors)-1)]
		lefttexture[0] = Animator.new().applyColor("res://Sprites/wallleft.png",currentcolors)
		righttexture[0] = Animator.new().applyColor("res://Sprites/wallright.png",currentcolors)
	super(_delta)
	oldy = background.yvalue

func _draw() -> void:
	if RuleManager.walls:
		super()
