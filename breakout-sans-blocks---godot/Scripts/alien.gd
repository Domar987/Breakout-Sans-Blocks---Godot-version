extends Area2D


var alienfile = FileAccess.get_file_as_string("res://Data/alien_colors.json")
var aliencolors = JSON.parse_string(alienfile)
var selectedcolors:Array

var aliensprites = ["res://Sprites/Alien/alienlight","res://Sprites/Alien/alienmain","res://Sprites/Alien/aliendark","res://Sprites/Alien/alienoutlinelight","res://Sprites/Alien/alienoutlinedark"]

@onready var RuleManager = $/root/Ingame/RuleManager
@onready var Ball = $/root/Ingame/Ball
@onready var Wall = $/root/Ingame/Wall
@onready var sprites:Array[AnimatedSprite2D] = [$Light,$Main,$Dark,$OutlineLight,$OutlineDark]

var fromLorR:bool = false
var xSpeed:float = 0.5
var xSpeedModifier:int
var currentKill:int
var entered:bool = false

var variant:int = randi_range(1,3)
var attacktimer:int = randi_range(250,500)
var projectilesource = preload("res://Objects/Projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentKill = RuleManager.kill
	var alientexture:Array[Texture2D] = []
	for i in range(0,5):
		sprites[i].sprite_frames = SpriteFrames.new()
		sprites[i].sprite_frames.add_animation("idle")
		alientexture.append(load(aliensprites[i]+str(variant)+".png"))
		#Animator.new().createAnimation(sprites[0].sprite_frames,"death",false,10.0)
		#Animator.new().createFrames("res://Sprites/Alien/alienexplosion.png",sprites[0].sprite_frames,4,"death")
	Animator.new().createAnimation(sprites[0].sprite_frames,"death",false,10.0)
	Animator.new().createFrames("res://Sprites/Alien/alienexplosion.png",sprites[0].sprite_frames,4,"death")
	var texwidth = alientexture[0].get_width() / 3
	var texheight = alientexture[0].get_height()
	for i1 in range(0,5):
		for i in range(0,4):
			var atlas = AtlasTexture.new()
			atlas.atlas = alientexture[i1]
			if i % 2 == 0:
				atlas.region = Rect2(texwidth * i, 0, texwidth, texheight)
				sprites[i1].sprite_frames.add_frame("idle",atlas, 3.0)
			else:
				atlas.region = Rect2(texwidth, 0, texwidth, texheight)
				sprites[i1].sprite_frames.add_frame("idle",atlas, 1.0)
		sprites[i1].play("idle")
	
	if randi_range(0,1):
		fromLorR = true
	var x = (2*int(fromLorR) - 1) * (get_viewport().size.x/(2*RuleManager.zoom) + 11)
	var y = 4 + 32 * randi_range(-get_viewport().size.y/(32*2*RuleManager.zoom),0)
	position = Vector2(x, y)
	xSpeed *= -2*int(fromLorR) + 1
	selectedcolors = selectColor(y)
	for i in range(0,5):
		sprites[i].modulate = Color(selectedcolors[i])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	attacktimer -= 1
	if attacktimer <= 0:
		shootProjectile()
		attacktimer = randi_range(250, 500)
	
	xSpeedModifier = RuleManager.kill - currentKill
	
	position.x += xSpeed * (1 + xSpeedModifier * (RuleManager.difficulty / 2) / 5.0)
	if abs(position.x) < abs(get_viewport().size.x/(2*RuleManager.zoom)) - 2* Wall.wallwidth and !entered:
		entered = true
	if entered and abs(position.x) >= abs(get_viewport().size.x/(2*RuleManager.zoom)) - 2 * Wall.wallwidth:
		xSpeed *= -1
		position.y += 32
		selectedcolors = selectColor(position.y)
		for i in range(0,5):
			sprites[i].modulate = Color(selectedcolors[i])


func _on_area_entered(area: Area2D) -> void:
	if area == Ball and sprites[0].animation == "idle":
		xSpeed = 0
		for i in range(1,5):
			sprites[i].queue_free()
		sprites[0].play("death")


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprites[0].animation == "death":
		RuleManager.kill += 1
		queue_free()

func selectColor(y:float)->Array:
	if y >= 36:
		return aliencolors[3]
	elif y >= 4:
		return aliencolors[2]
	elif y >= -12:
		return aliencolors[1]
	else:
		return aliencolors[0]

func shootProjectile()->void:
	var projectile = projectilesource.instantiate()
	var projectilevariant:int = randi_range(1,2)
	projectile.texturepath = "res://Sprites/Alien/alienprojectile"+str(projectilevariant)+".png"
	projectile.blasttexturepath = "res://Sprites/Alien/alienprojectileexplosion.png"
	projectile.frames = projectilevariant*2 + 2
	projectile.blastframes = 4
	projectile.damage = 1
	projectile.speed = 20
	projectile.position = position
	projectile.modulate = sprites[0].modulate
	add_sibling(projectile)
