class_name EdgeBorder extends Area2D

@onready var RuleManager = $/root/Ingame/RuleManager
var lefttexture:Array[Texture2D]
var righttexture:Array[Texture2D]
var wallwidth:int
var wallheight:int
var ySpeedAddition:float = 0.0
var oldzoom:float

func _physics_process(delta: float) -> void:
	ySpeedAddition += RuleManager.ySpeed * delta
	if ySpeedAddition >= 10:
		ySpeedAddition = 0
	if RuleManager.zoom != oldzoom or RuleManager.ySpeed != 0:
		queue_redraw()
	oldzoom = RuleManager.zoom

func _draw() -> void:
	for i in range(0,540/(wallheight*RuleManager.zoom)+3):
		var x = 960/(2*RuleManager.zoom) + 1
		var y = (i-2)*wallheight-540/(2*RuleManager.zoom)
		drawfuncfunc(i,x,y)

func drawfunc(index:int,x:float,y:float)->void:
	draw_texture(lefttexture[index],Vector2(-x, y + ySpeedAddition))
	draw_texture(righttexture[index],Vector2(x - wallwidth, y + ySpeedAddition))

func drawfuncfunc(i:int,x:float,y:float)->void:
	pass
