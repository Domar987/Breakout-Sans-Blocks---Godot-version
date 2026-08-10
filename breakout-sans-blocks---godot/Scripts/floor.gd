extends Area2D

var additionalY:float = 0.0
@onready var RuleManager = $/root/Ingame/RuleManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	additionalY += RuleManager.ySpeed * delta
	position.y = 540/(2*RuleManager.zoom) - 5 + additionalY
	if position.y > 540/(2*RuleManager.zoom) + 200:
		queue_free()
