extends TextureRect

@export var background:Sprite2D

@onready var grabber = $Grabber
@onready var ticks:Array = [$Tick,$Tick2,$Tick3]

var levelvals:Array = [0,1000, 5000, 16000, 40000]
var currentLimit:int

var ticklerps:Array = [0.0,0.0,0.0]
var grabberlerp:float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var lerpweight = delta * 20
	currentLimit = levelvals[background.level+1]
	#print(background.level+1," ",currentLimit)
	var min = 27
	for i in range(0,3):
		ticklerps[i] = min(min, 29 - 29*levelvals[i+1]/currentLimit)
		if ticklerps[i] == min:
			min -= 2
		if abs(ticks[i].position.y - ticklerps[i]) > 1:
			ticks[i].position.y = lerpf(ticks[i].position.y,ticklerps[i],lerpweight)
		else:
			ticks[i].position.y = ticklerps[i]
	grabberlerp = max(0,28 - 27*background.yvalue/currentLimit)
	if abs(grabber.position.y - grabberlerp) > 1:
		grabber.position.y = lerpf(grabber.position.y,grabberlerp,lerpweight)
	else:
		grabber.position.y = grabberlerp
