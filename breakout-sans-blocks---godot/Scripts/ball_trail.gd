extends Line2D

@export var trail_length = 50
@export var drawline:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if drawline:
		trail_length = 50 / Engine.time_scale
		add_point(get_parent().global_position)
	else:
		trail_length -= 1
	if points.size() > trail_length:
		remove_point(0)
