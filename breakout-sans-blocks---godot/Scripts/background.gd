extends Sprite2D

var grad:GradientTexture1D = GradientTexture1D.new()
var timer:float = 36.0
var yvalue:float = 0.0
@onready var RuleManager = $/root/Ingame/RuleManager
var projectilesource:PackedScene


var bgfile = FileAccess.get_file_as_string("res://Data/bg_colors.json")
var bgcolors = JSON.parse_string(bgfile)

var currentcolors:Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grad.gradient = Gradient.new()
	grad.gradient.offsets = texture.gradient.offsets
	grad.gradient.colors = texture.gradient.colors
	texture.gradient = Gradient.new()
	texture.gradient.interpolation_mode = 2
	projectilesource = preload("res://Objects/BackgroundItem.tscn")
	for i in range(0,randi_range(3,8)):
		shootProjectile(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	timer -= RuleManager.ySpeed * delta
	if timer <= 0:
		timer = 36.0
		shootProjectile(true)
		
	scale.y = 960 /(RuleManager.zoom)
	scale.x = (540 /(RuleManager.zoom))/256
	
	yvalue += delta * RuleManager.ySpeed
	
	currentcolors = bgcolors[min(int(yvalue/(4000.0/3)),len(bgcolors)-1)]
	texture.gradient = getGradient(grad.gradient,yvalue/4000,yvalue/4000+0.11)
	
	$Label.text = str(yvalue)+"\n"+str(RuleManager.ySpeed)+"\n"+str(delta)
	$Label.scale.y = (RuleManager.zoom) /960
	$Label.scale.x = 1/((540 /(RuleManager.zoom))/256)

func getGradient(gradient:Gradient,point1:float,point2:float)->Gradient:
	var gr = Gradient.new()
	var offsets:PackedFloat32Array = []
	var colors:PackedColorArray = []
	offsets.append(0.0)
	colors.append(gradient.sample(point1))
	for point in gradient.offsets:
		if point > point1 and point < point2:
			var newpoint:float = (point - point1) / (point2 - point1)
			offsets.append(newpoint)
			colors.append(gradient.sample(point))
	offsets.append(1.0)
	colors.append(gradient.sample(point2))
	##var gray:float
	#for i in range(len(colors)):
		##gray = (colors[i].r + colors[i].g + colors[i].b) / 3.0
		##colors[i] = lerp(Color(gray,gray,gray),colors[i],0.5)
		#colors[i].s *= 0.5
		#colors[i].v *= 0.8
	gr.offsets = offsets
	gr.colors = colors
	#gr.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CUBIC
	return gr

func shootProjectile(fromTop:bool)->void:
	var projectile = projectilesource.instantiate()
	projectile.fromTop = fromTop
	projectile.scale = Vector2.ONE
	projectile.speed = RuleManager.ySpeed
	projectile.parent = self
	add_sibling.call_deferred(projectile)

#func _draw() -> void:
	#pass
