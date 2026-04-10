extends Line2D

@export var trail_length = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = -get_parent().global_position
	add_point(get_parent().global_position)
	if points.size() > 50:
		remove_point(0)
