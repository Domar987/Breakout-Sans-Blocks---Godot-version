extends RigidBody2D

@onready var sprite = $AnimatedSprite2D
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= 1
	if linear_velocity.y < 10:
		sprite.frame = 0
	elif linear_velocity.y < 20:
		sprite.frame = 1
	elif linear_velocity.y < 40:
		sprite.frame = 2
	else:
		sprite.frame = 3
	pass


func _on_body_entered(body: Node) -> void:
	if body == $/root/Ingame/Platform:
		linear_velocity.x = (position.x - body.position.x) * body.length/30
	elif body == $/root/Ingame/Wall and timer <= 0:
		timer = 100
		linear_velocity.x *= -1
