extends Area2D

@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
var texturepath:String
var frames:int
var damage:int
var speed:float
var direction:Vector2

var texture:Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if direction == null or direction == Vector2.ZERO:
		direction = Vector2.DOWN
	sprite.sprite_frames = SpriteFrames.new()
	texture = load(texturepath)
	var texwidth = texture.get_width() / frames
	var texheight = texture.get_height()
	for i in range(0,frames):
		var atlas = AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(texwidth * i, 0, texwidth, texheight)
		sprite.sprite_frames.add_frame("default",atlas, 1.0)
	sprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += speed * delta * direction
