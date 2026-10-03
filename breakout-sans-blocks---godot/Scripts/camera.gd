extends Camera2D

var shakeAmount:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shakeAmount > 0:
		var randangle = randf() * 2 * PI
		position = Vector2(sin(randangle),cos(randangle)) * shakeAmount * (randf()/2 + 0.75)
	else:
		shakeAmount = 0
		position = Vector2.ZERO
