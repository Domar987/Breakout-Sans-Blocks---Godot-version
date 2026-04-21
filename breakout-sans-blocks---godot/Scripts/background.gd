extends Sprite2D

var grad:GradientTexture1D = GradientTexture1D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grad.gradient = Gradient.new()
	grad.gradient.offsets = texture.gradient.offsets
	grad.gradient.colors = texture.gradient.colors
	texture.gradient = Gradient.new()
	texture.gradient.interpolation_mode = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	texture.gradient = getGradient(grad.gradient,0.5,1.0)
	scale.y = get_viewport().size.x
	#Color(0.3373, 0.3098, 0.3216, 1.0)
	#Color(0.3804, 0.1529, 0.1294, 1.0)
	#Color(0.1608, 0.2471, 0.1294, 1.0)
	#Color(0.3922, 0.2118, 0.2941, 1.0)





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
	gr.offsets = offsets
	gr.colors = colors
	return gr
