class_name MechaPart extends GatorTooth

var xSpeed:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xSpeed = -sign(scale.x)*(randf() * 100)
	super()
	canfall = true
	speed = -(randf() * 200 + 75)
	sprite.animation = str(randi_range(1,4))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)
	position.x += xSpeed * delta

func _on_animated_sprite_2d_animation_finished() -> void:
	super()
