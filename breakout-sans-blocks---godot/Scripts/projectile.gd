extends Area2D

@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
var texturepath:String
var blasttexturepath:String
var frames:int
var blastframes:int
var damage:int
var speed:float
var direction:Vector2

var texture:Texture2D

@onready var ball:Area2D = $/root/Ingame/Ball
@onready var platform:Area2D = $/root/Ingame/Platform
@onready var RuleManager = $/root/Ingame/RuleManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if direction == null or direction == Vector2.ZERO:
		direction = Vector2.DOWN
	sprite.sprite_frames = SpriteFrames.new()
	
	texture = load(texturepath)
	var texwidth = texture.get_width() / frames
	var texheight = texture.get_height()
	var rectShape = RectangleShape2D.new()
	rectShape.size = Vector2(texwidth,texheight)
	$CollisionShape2D.set_shape(rectShape)
	
	Animator.new().createAnimation(sprite.sprite_frames,"default",true,10.0)
	Animator.new().createFramesAuto(texturepath,sprite.sprite_frames,frames,"default")
	Animator.new().createAnimation(sprite.sprite_frames,"blast",false,10.0)
	Animator.new().createFramesAuto(blasttexturepath,sprite.sprite_frames,blastframes,"blast")
	
	sprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if sprite.animation != "blast":
		position += speed * delta * direction * (1 + RuleManager.difficulty/10)


func _on_area_entered(area: Area2D) -> void:
	if sprite.animation != "blast":
		if area == ball:
			sprite.play("blast")
		elif area == platform:
			RuleManager.health -= damage
			sprite.play("blast")


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "blast":
		queue_free()
