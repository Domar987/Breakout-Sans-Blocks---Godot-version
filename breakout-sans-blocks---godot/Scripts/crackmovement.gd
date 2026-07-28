extends Sprite2D

var force:Vector2
var velocity:Vector2 = Vector2.ZERO
var fall:bool = false
var zoom:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	force = Vector2(position.x,position.y) + Vector2(25 * (randf() - 0.5),25 * (randf() - 0.5))
	await get_tree().create_timer(0.25).timeout
	fall = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fall:
		rotation += force.x * delta * delta * delta
		velocity += force * delta
		velocity.y += 980 * delta
		position += velocity * delta
		if position.y > 540/(2*1.6):
			queue_free()
	else:
		position += Vector2((3/zoom)*(randf() - 0.5),(3/zoom)*(randf() - 0.5))
