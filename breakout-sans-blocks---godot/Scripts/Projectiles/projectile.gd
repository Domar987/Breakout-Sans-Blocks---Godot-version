class_name Projectile extends Area2D

@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
var damage:int
var speed:float
var direction:Vector2
var point:int

var texture:Texture2D

@onready var ball:Area2D = $/root/Ingame/Ball
@onready var platform:Area2D = $/root/Ingame/Platform
@onready var RuleManager = $/root/Ingame/RuleManager

var pointext = load("res://Objects/Score.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	area_entered.connect(_on_area_entered)
	if direction == null or direction == Vector2.ZERO:
		direction = Vector2.DOWN
	sprite.play("1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if sprite.animation != "blast":
		position += speed * delta * direction
	if position.y > 540/(2*RuleManager.zoom) + 160 or abs(position.x) > (960/(2*RuleManager.zoom)) + 100:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if sprite.animation != "blast":
		if area == ball:
			balltouched()
		elif area == platform.HurtArea:
			plattouched()

func balltouched()->void:
	pointAdd()
	ball.velocity.y = min(-88.5,ball.velocity.y)
	sprite.play("blast")

func plattouched()->void:
	RuleManager.health -= damage
	sprite.play("blast")

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "blast":
		queue_free()

func pointBase()->int:
	return point * (10 + RuleManager.difficulty)/10
func pointCalculation()->int:
	return pointBase()

func pointAdd()->void:
	var projectile = pointext.instantiate()
	projectile.position = position
	projectile.point = pointCalculation()
	add_sibling(projectile)
	RuleManager.points += pointCalculation()
