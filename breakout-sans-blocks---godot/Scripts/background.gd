extends Sprite2D

var grad:GradientTexture1D = GradientTexture1D.new()
var yvalue:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grad.gradient = Gradient.new()
	grad.gradient.offsets = texture.gradient.offsets
	grad.gradient.colors = texture.gradient.colors
	texture.gradient = Gradient.new()
	texture.gradient.interpolation_mode = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	yvalue += delta / 1000.0
	texture.gradient = getGradient(grad.gradient,yvalue,yvalue+0.1)
	scale.y = get_viewport().size.x

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
	#var gray:float
	for i in range(len(colors)):
		#gray = (colors[i].r + colors[i].g + colors[i].b) / 3.0
		#colors[i] = lerp(Color(gray,gray,gray),colors[i],0.5)
		colors[i].s *= 0.7
		colors[i].v *= 0.75
	gr.offsets = offsets
	gr.colors = colors
	#gr.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CUBIC
	return gr

func _draw() -> void:
	pass
