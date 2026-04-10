extends StaticBody2D
var colShape1 = WorldBoundaryShape2D.new()
var colShape2 = WorldBoundaryShape2D.new()
func _ready() -> void:
	colShape1.normal = Vector2(1,0)
	colShape2.normal = Vector2(-1,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	colShape1.distance = -get_viewport().size.x/(2*3)
	colShape2.distance = -get_viewport().size.x/(2*3)
	$CollisionShape2D1.shape = colShape1
	$CollisionShape2D2.shape = colShape2
