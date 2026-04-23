extends EdgeBorder

var colShape1 = WorldBoundaryShape2D.new()
var colShape2 = WorldBoundaryShape2D.new()


func _ready() -> void:
	lefttexture = [load("res://Sprites/wallleft.png")]
	righttexture = [load("res://Sprites/wallright.png")]
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
	super(_delta)

func _draw() -> void:
	if RuleManager.walls:
		super()
