extends TextureRect

@export var background:Sprite2D

@onready var grabber = $Grabber
@onready var ticks:Array = [$Tick,$Tick2,$Tick3]

var levelvals:Array = [0,1000, 5000, 16000, 40000]
var currentLimit:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currentLimit = levelvals[background.level+1]
	#print(background.level+1," ",currentLimit)
	var min = 27
	for i in range(0,3):
		ticks[i].position.y = min(min, 29 - 29*levelvals[i+1]/currentLimit)
		if ticks[i].position.y == min:
			min -= 2
	grabber.position.y = max(0,29 - 29*background.yvalue/currentLimit)
