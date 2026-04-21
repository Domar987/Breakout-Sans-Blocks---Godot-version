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
	sprite.sprite_frames.add_animation("default")
	sprite.sprite_frames.add_animation("blast")
	sprite.sprite_frames.set_animation_loop("default",true)
	sprite.sprite_frames.set_animation_loop("blast",false)
	sprite.sprite_frames.set_animation_speed("default",10.0)
	sprite.sprite_frames.set_animation_speed("blast",10.0)
	var texwidth = texture.get_width() / frames
	var texheight = texture.get_height()
	for i in range(0,frames):
		var atlas = AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(texwidth * i, 0, texwidth, texheight)
		sprite.sprite_frames.add_frame("default",atlas, 1.0)
	
	var rectShape = RectangleShape2D.new()
	rectShape.size = Vector2(texwidth,texheight)
	$CollisionShape2D.set_shape(rectShape)
	
	texture = load(blasttexturepath)
	texwidth = texture.get_width() / blastframes
	texheight = texture.get_height()
	for i in range(0,blastframes):
		var atlas = AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(texwidth * i, 0, texwidth, texheight)
		sprite.sprite_frames.add_frame("blast",atlas, 1.0)
	sprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if sprite.animation != "blast":
		position += speed * delta * direction


func _on_area_entered(area: Area2D) -> void:
	if sprite.animation != "blast":
		if area == ball:
			sprite.play("blast")
		elif area == platform:
			RuleManager.health -= 1
			sprite.play("blast")


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "blast":
		queue_free()
