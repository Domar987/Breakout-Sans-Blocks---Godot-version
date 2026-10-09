extends Sprite2D

var projectilesource:PackedScene

@onready var RuleManager = $/root/Ingame/RuleManager

var timer:float = 24.0

var bgfile = FileAccess.get_file_as_string("res://Data/bg_colors.json")
var bgcolors = JSON.parse_string(bgfile)

var currentcolors:Array

var yvalue:float
var level:int = 0
var levelvals:Array = [0,1000,5000,16000, 40000]

var rect1:Rect2
var rect2:Rect2
var recttrans:Rect2
var transtexture:Texture2D = load("res://Sprites/Background/bgtransitionnew.png")
var transheight = transtexture.get_height()

var drawtrans:bool = false
var startY:float

var oldzoom:float = 0.0

#var endless:bool = true

@onready var CheevoHandler = $/root/Ingame/UI/BottomRight/CheevoHandler

var initialBGpos:Array[Vector2] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Time:",Time.get_time_dict_from_system())
	currentcolors = bgcolors[level]
	projectilesource = preload("res://Objects/Projectiles/BackgroundItem.tscn")
	for i in range(0,randi_range(6,16)):
		shootProjectile(false,0)

	get_child(0).modulate = Color(bgcolors[0][0],0.5)
var lastpos:float = -10000

func shootProjectile(fromTop:bool,retry:int)->void:
	if retry > 50:
		return
	var projectile = projectilesource.instantiate()
	projectile.scale = Vector2.ONE
	if randi_range(0,1) == 1:
		projectile.scale.x = -1
	if fromTop:
		projectile.position.y = -540/(2*RuleManager.zoom) - 50
	else:
		projectile.position.y = randi_range(-540/(2*RuleManager.zoom),540/(2*RuleManager.zoom))
	var tmpchanc = randi_range(0,1000)
	
	if tmpchanc <= 75:
		projectile.special = 1
		projectile.position.x = -960/(2*RuleManager.zoom) + randi_range(-32,8)
		projectile.position.x *= projectile.scale.x
	else:
		projectile.position.x = randi_range(-960/(2*RuleManager.zoom),960/(2*RuleManager.zoom))
		if tmpchanc == 1000:
			projectile.special = 2
	projectile.speed = RuleManager.ySpeed
	projectile.parent = self
	
	var overlap:bool = false
	if fromTop:
		if abs(projectile.position.x - lastpos) < 90:
			overlap = true
	else:
		for oldPos in initialBGpos:
			if abs(projectile.position.x - oldPos.x) < 90 and abs(projectile.position.y - oldPos.y) < 66:
				overlap = true
				break
	
	if overlap:
		shootProjectile(fromTop,retry+1)
	else:
		if fromTop:
			lastpos = projectile.position.x
		initialBGpos.append(projectile.position)
		add_sibling.call_deferred(projectile,true)

@onready var noise:TextureRect = get_child(0)

func _physics_process(delta: float) -> void:
	yvalue += delta * RuleManager.ySpeed
	if yvalue > 0:
		noise.set_instance_shader_parameter("yValue",yvalue)
	for i in range(1,len(levelvals)):
		if yvalue > levelvals[i] and i > level:
			print("Time:",Time.get_time_dict_from_system())
			#if endless:
				#if yvalue > 16000:
					#levelvals.append(levelvals[-1] * 2.5)
				#var randlvl = randi_range(0,3)
				#level = randlvl
				#RuleManager.level = randlvl
			#else:
				#level = i
				#RuleManager.level = level + 1
			RuleManager.level = level + 1
			if i >= 4:
				print("Boss fight")
			else:
				level = i
				levelChange(yvalue)
	
	timer -= RuleManager.ySpeed * delta
	if timer <= 0:
		timer = 24.0
		shootProjectile(true,0)
		
	
	drawfunc()
	
	oldzoom = RuleManager.zoom

func levelChange(tmpY:float)->void:
	currentcolors = bgcolors[level]
	self.startY = tmpY + transheight
	drawtrans = true
	get_child(0).modulate = Color(bgcolors[level][0],0.5)
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
