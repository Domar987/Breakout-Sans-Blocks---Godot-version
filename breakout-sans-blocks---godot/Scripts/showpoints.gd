extends TextureRect

@export var ruleManager:RuleManager
@onready var slots:Array = get_children()
var values:Array = [0,0,0,0,0,0,0,0]
var lerpvalues:Array = [0,0,0,0,0,0,0,0]

var spintimer:float = 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slots.reverse()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var loop:int = ruleManager.points
	for i in range(len(values)):
		values[i] = loop % 10
		loop /= 10
	if spintimer <= 0:
		spintimer = 0.05
		for i in range(len(values)):
			if lerpvalues[i] == values[i]:
				slots[i].frame = lerpvalues[i] + 3
			else:
				slots[i].frame = lerpvalues[randi_range(0,2)]
				lerpvalues[i] += 1
				lerpvalues[i] = lerpvalues[i] % 10
	else:
		spintimer -= delta
