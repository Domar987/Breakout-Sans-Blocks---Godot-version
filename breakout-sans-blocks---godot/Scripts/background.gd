extends Sprite2D

var projectilesource:PackedScene

@onready var RuleManager = $/root/Ingame/RuleManager

var timer:float = 24.0

var bgfile = FileAccess.get_file_as_string("res://Data/bg_colors.json")
var bgcolors = JSON.parse_string(bgfile)

var currentcolors:Array

var yvalue:float
var level:int = 0
var levelvals:Array = [0,200,1500,4000, 10000]

var rect1:Rect2
var rect2:Rect2
var recttrans:Rect2
var transtexture:Texture2D = load("res://Sprites/Background/bgtransitionnew.png")
var transheight = transtexture.get_height()

var drawtrans:bool = false
var startY:float

var oldzoom:float = 0.0

@onready var CheevoHandler = $/root/Ingame/UI/BottomRight/CheevoHandler

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentcolors = bgcolors[level]
	projectilesource = preload("res://Objects/Projectiles/BackgroundItem.tscn")
	for i in range(0,randi_range(6,16)):
		shootProjectile(false)

func shootProjectile(fromTop:bool)->void:
	var projectile = projectilesource.instantiate()
	projectile.fromTop = fromTop
	projectile.scale = Vector2.ONE
	projectile.speed = RuleManager.ySpeed
	projectile.parent = self
	add_sibling.call_deferred(projectile,true)


func _physics_process(delta: float) -> void:
	yvalue += delta * RuleManager.ySpeed
	for i in range(1,4):
		if yvalue > levelvals[i] and i > level:
			level = i
			RuleManager.level = level + 1
			if level >= 4:
				print("Boss fight")
			else:
				levelChange(yvalue)
	
	timer -= RuleManager.ySpeed * delta
	if timer <= 0:
		timer = 24.0
		shootProjectile(true)
		
	
	drawfunc()
	
	oldzoom = RuleManager.zoom

func levelChange(tmpY:float)->void:
	currentcolors = bgcolors[level]
	self.startY = tmpY + transheight
	drawtrans = true
	RuleManager.levelChange()
	
	cheevo()

func _draw() -> void:
	var x = -960/(2*RuleManager.zoom)
	var y = -540/(2*RuleManager.zoom)
	if not drawtrans:
		draw_rect(Rect2(Vector2(x,y),Vector2(-2*x,-2*y)),Color(bgcolors[level][2]))
	else:
		rect1 = Rect2(Vector2(x,y - (startY-yvalue)), Vector2(-2*x,-2*y + transheight))
		rect2 = Rect2(Vector2(x,3 * y - (startY-yvalue + transheight)), Vector2(-2*x,-2*y + transheight))
		recttrans = Rect2(Vector2(-480,y - (startY-yvalue)), Vector2(-960,transheight))

		draw_rect(rect1,Color(bgcolors[level-1][2]))
		draw_rect(rect2,Color(bgcolors[level][2]))
		draw_texture_rect(transtexture,recttrans,true,Color(bgcolors[level][2]))

func drawfunc()->void:
	if drawtrans:
		if yvalue < startY + 540/(RuleManager.zoom) + transheight:
			queue_redraw()
		else:
			drawtrans = false
	elif RuleManager.zoom != oldzoom:
		queue_redraw()

func cheevo()->void:
	if level >= 2 and not RuleManager.ufocheevoFail:
		CheevoHandler.unlockCheevo(2)
