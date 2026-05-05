class_name Drop extends Projectile

@onready var prizeSprite = $Prize
var prizeposX:float = 0
var prizeposY:float = 0
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
	create_tween().set_trans(Tween.TRANS_BOUNCE).tween_property(prizeSprite,"scale",Vector2.ONE,0.75)


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
	prizeSprite.position = Vector2(prizeposX,prizeposY)
	super(delta)

func balltouched()->void:
	super()
	pop()

func plattouched()->void:
	sprite.play("blast")
	pop()

func pop()->void:
	match variant:
		0:
			if RuleManager.health < RuleManager.maxHealth:
				RuleManager.health += 1
		1:
			pass
		2:
			pass
	
	
	var poptween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT_IN)
	poptween.tween_property(self,"prizeposY",-global_position.y + 64 + 540/(2*RuleManager.zoom),0.55)
	poptween.set_ease(Tween.EASE_OUT)
	poptween.tween_property(self,"prizeposX",-global_position.x/3,0.55)
	poptween.tween_property(prizeSprite,"scale",Vector2(24,24),0.55)
	var popcolortween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	popcolortween.tween_property(prizeSprite,"modulate",Color(20,20,20,0.9),0.2)
	popcolortween.chain().tween_property(prizeSprite,"modulate",Color(0.2,0.2,0.2,0.35),0.25)
	popcolortween.chain().tween_property(prizeSprite,"modulate",Color(0,0,0,0),0.25)

func _on_animated_sprite_2d_animation_finished() -> void:
	super()
	if sprite.animation == "form":
		$CollisionShape2D.disabled = false
		sprite.play("1")
