class_name Drop extends Projectile

@onready var prizeSprite = $Prize
var tier:int = 1
var tiervariants = [[],[0,2],[0,1,3,5],[0,1,4,5,6],[7]]
var variant:int = 1
var sineTimer:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	sprite.play("form")
	speed = 1
	variant = tiervariants[tier][randi_range(0,len(tiervariants[tier])-1)]
	prizeSprite.texture = Animator.new().chooseTexture("res://Sprites/drops.png",8,variant)
	prizeSprite.scale = Vector2.ZERO
	create_tween().set_trans(Tween.TRANS_BOUNCE).tween_property(prizeSprite,"scale",Vector2.ONE,0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if sprite.animation != "blast":
		sineTimer += 25 * delta
		direction.x = sin(deg_to_rad(sineTimer)) * 10
		if randi_range(0, 10) == 2:
			if direction.y > 12:
				direction.y += randf_range(-1.5, 1.0)
			else:
				direction.y += randf_range(0, 1.0)
	super(delta)

func balltouched()->void:
	super()

func plattouched()->void:
	sprite.play("blast")

func _on_animated_sprite_2d_animation_finished() -> void:
	super()
	if sprite.animation == "form":
		sprite.play("1")
