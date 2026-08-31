class_name MechaPart extends GatorTooth


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	speed = randf() * 50


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)

func _on_animated_sprite_2d_animation_finished() -> void:
	super()
