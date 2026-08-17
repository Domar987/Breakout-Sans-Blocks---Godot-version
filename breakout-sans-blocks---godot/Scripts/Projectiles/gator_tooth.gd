class_name GatorTooth extends Projectile

var canfall=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	speed = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if canfall:
		speed += gravity * delta
	super(delta)

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "1":
		canfall = true
	super()
