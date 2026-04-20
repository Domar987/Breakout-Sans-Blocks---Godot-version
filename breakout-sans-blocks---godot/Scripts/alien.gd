extends Area2D


var alienfile = FileAccess.get_file_as_string("res://Data/alien_colors.json")
var aliencolors = JSON.parse_string(alienfile)

var aliensprites = ["res://Sprites/alien1.png","res://Sprites/alien2.png"]

@onready var RuleManager = $/root/Ingame/RuleManager
@onready var Ball = $/root/Ingame/Ball
@onready var Wall = $/root/Ingame/Wall
@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D

var fromLorR:bool = false
var xSpeed:float = 0.5
var entered:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var alientexture:Texture2D = load(aliensprites[randi_range(0,1)])
	#for x in range(alientexture.get_width()):
		#for y in range(alientexture.get_height()):
			#var pixel:Color = alientexture.get_image().get_pixel(x,y)
			#if pixel == Color.WHITE:
	var texwidth = alientexture.get_width() / 3
	var texheight = alientexture.get_height()
	sprite.sprite_frames.add_animation("idle")
	for i in range(0,4):
		var atlas = AtlasTexture.new()
		atlas.atlas = alientexture
		if i % 2 == 0:
			atlas.region = Rect2(texwidth * i, 0, texwidth, texheight)
			sprite.sprite_frames.add_frame("idle",atlas, 3.0)
		else:
			atlas.region = Rect2(texwidth, 0, texwidth, texheight)
			sprite.sprite_frames.add_frame("idle",atlas, 1.0)
	sprite.sprite_frames.set_animation_loop("idle", true)
	sprite.sprite_frames.set_animation_speed("idle", 10.0)
	sprite.play("idle")
	
	if randi_range(0,1):
		fromLorR = true
	var x = (2*int(fromLorR) - 1) * (get_viewport().size.x/(2*RuleManager.zoom) + 11)
	var y = 4 + 32 * randi_range(-get_viewport().size.y/(32*2*RuleManager.zoom),0)
	position = Vector2(x, y)
	xSpeed *= -2*int(fromLorR) + 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += xSpeed
	if abs(position.x) < abs(get_viewport().size.x/(2*RuleManager.zoom)) - 2* Wall.wallwidth and !entered:
		entered = true
	if entered and abs(position.x) >= abs(get_viewport().size.x/(2*RuleManager.zoom)) - 2 * Wall.wallwidth:
		xSpeed *= -1
		position.y += 32
	pass


func _on_area_entered(area: Area2D) -> void:
	if area == Ball:
		xSpeed = 0
		sprite.play("death")


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "death":
		queue_free()
