extends Sprite2D
#
#var grad:GradientTexture1D = GradientTexture1D.new()
#var timer:float = 36.0
#var yvalue:float = 0.0
#@onready var RuleManager = $/root/Ingame/RuleManager
var projectilesource:PackedScene
#
#
#var bgfile = FileAccess.get_file_as_string("res://Data/bg_colors.json")
#var bgcolors = JSON.parse_string(bgfile)
#
#var currentcolors:Array
#
## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentcolors = bgcolors[level]
	#grad.gradient = Gradient.new()
	#grad.gradient.offsets = texture.gradient.offsets
	#grad.gradient.colors = texture.gradient.colors
	#texture.gradient = Gradient.new()
	#texture.gradient.interpolation_mode = 2
	projectilesource = preload("res://Objects/Projectiles/BackgroundItem.tscn")
	for i in range(0,randi_range(6,16)):
		shootProjectile(false)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
	#timer -= RuleManager.ySpeed * delta
	#if timer <= 0:
		#timer = 36.0
		#shootProjectile(true)
		#
	#scale.y = 960 /(RuleManager.zoom)
	#scale.x = (540 /(RuleManager.zoom))/256
	#
	#yvalue += delta * RuleManager.ySpeed
	#
	#currentcolors = bgcolors[min(int((max(0,yvalue-1000))/(1000)),len(bgcolors)-1)]
	#var gradientval = ((yvalue-1000)/3000)/scale.x
	#texture.gradient = getGradient(grad.gradient,gradientval-0.11,gradientval)
	#
	#$Label.text = str(yvalue)+"\n"+str(RuleManager.ySpeed)+"\n"+str(delta)
	#$Label.scale.y = (RuleManager.zoom) /960
	#$Label.scale.x = 1/((540 /(RuleManager.zoom))/256)
#
#func getGradient(gradient:Gradient,point1:float,point2:float)->Gradient:
	#var gr = Gradient.new()
	#var offsets:PackedFloat32Array = []
	#var colors:PackedColorArray = []
	#offsets.append(0.0)
	#colors.append(gradient.sample(point1))
	#for point in gradient.offsets:
		#if point > point1 and point < point2:
			#var newpoint:float = (point - point1) / (point2 - point1)
			#offsets.append(newpoint)
			#colors.append(gradient.sample(point))
	#offsets.append(1.0)
	#colors.append(gradient.sample(point2))
	###var gray:float
	##for i in range(len(colors)):
		###gray = (colors[i].r + colors[i].g + colors[i].b) / 3.0
		###colors[i] = lerp(Color(gray,gray,gray),colors[i],0.5)
		##colors[i].s *= 0.5
		##colors[i].v *= 0.8
	#gr.offsets = offsets
	#gr.colors = colors
	##gr.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CUBIC
	#return gr

func shootProjectile(fromTop:bool)->void:
	var projectile = projectilesource.instantiate()
	projectile.fromTop = fromTop
	projectile.scale = Vector2.ONE
	projectile.speed = RuleManager.ySpeed
	projectile.parent = self
	add_sibling.call_deferred(projectile,true)

@onready var RuleManager = $/root/Ingame/RuleManager

var timer:float = 36.0

#var firstdraw:bool = true

var bgfile = FileAccess.get_file_as_string("res://Data/bg_colors.json")
var bgcolors = JSON.parse_string(bgfile)

var currentcolors:Array

var yvalue:float
var level:int = 0
var levelvals:Array = [0,200,800,2000]

var rect1:Rect2
var rect2:Rect2
var recttrans:Rect2
var transtexture:Texture2D = load("res://Sprites/Background/bgtransitionnew.png")
var transheight = transtexture.get_height()

var drawtrans:bool = false
var startY:float

var oldzoom:float = 0.0

func _physics_process(delta: float) -> void:
	yvalue += delta * RuleManager.ySpeed
	for i in range(1,4):
		if yvalue > levelvals[i] and i > level:
			level = i
			levelChange(yvalue)
	
	timer -= RuleManager.ySpeed * delta
	if timer <= 0:
		timer = 36.0
		shootProjectile(true)
		
	
	if drawtrans:
		if yvalue < startY + 540/(RuleManager.zoom) + transtexture.get_height():
			queue_redraw()
		else:
			drawtrans = false
	elif RuleManager.zoom != oldzoom:
		#firstdraw = true
		queue_redraw()
	oldzoom = RuleManager.zoom
	
	#$Label.text = str(startY) + "\n" + str(yvalue)1

func levelChange(tmpY:float)->void:
	currentcolors = bgcolors[level]
	self.startY = tmpY + transtexture.get_height()
	drawtrans = true
	RuleManager.levelChange()

func _draw() -> void:
	var x = -960/(2*RuleManager.zoom)
	var y = -540/(2*RuleManager.zoom)
	if not drawtrans:#firstdraw:
		draw_rect(Rect2(Vector2(x,y),Vector2(-2*x,-2*y)),Color(bgcolors[level][2]))
		#firstdraw = false
	else:
		rect1 = Rect2(Vector2(x,y - (startY-yvalue)), Vector2(-2*x,-2*y + transheight))
		rect2 = Rect2(Vector2(x,3 * y - (startY-yvalue + transheight)), Vector2(-2*x,-2*y + transheight))
		recttrans = Rect2(Vector2(-480,y - (startY-yvalue)), Vector2(-960,transheight))

		draw_rect(rect1,Color(bgcolors[level-1][2]))
		draw_rect(rect2,Color(bgcolors[level][2]))
		draw_texture_rect(transtexture,recttrans,true,Color(bgcolors[level][2]))
	
