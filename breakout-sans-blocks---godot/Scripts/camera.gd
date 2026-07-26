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

func addShake(amount:float, falloffdelay:float, fallofftime:float) -> void:
	shakeAmount += amount
	await get_tree().create_timer(falloffdelay).timeout
	var decreaseAmount = amount / (fallofftime * 10)
	while fallofftime > 0:
		await get_tree().create_timer(0.1).timeout
		shakeAmount -= decreaseAmount
		fallofftime -= 0.1
