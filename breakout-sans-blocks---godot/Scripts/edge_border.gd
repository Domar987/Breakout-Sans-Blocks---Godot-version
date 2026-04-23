class_name EdgeBorder extends Area2D

@onready var RuleManager = $/root/Ingame/RuleManager
var lefttexture:Array[Texture2D]
var righttexture:Array[Texture2D]
var wallwidth:int
var wallheight:int
var ySpeedAddition:float = 0.0
var ySpeed:float = 0.0
var oldzoom:float

func _process(_delta: float) -> void:
	ySpeedAddition -= ySpeed
	if ySpeedAddition <= -10:
		ySpeedAddition = 0
	if RuleManager.zoom != oldzoom or ySpeed != 0:
		queue_redraw()
	oldzoom = RuleManager.zoom

func _draw() -> void:
	for i in range(0,540/(wallheight*RuleManager.zoom)+1):
		var x = 960/(2*RuleManager.zoom) + 1
		var y = i*wallheight-540/(2*RuleManager.zoom)
		draw_texture(lefttexture[i%len(lefttexture)],Vector2(-x, y + ySpeedAddition))
		draw_texture(righttexture[i%len(righttexture)],Vector2(x - wallwidth, y + ySpeedAddition))
