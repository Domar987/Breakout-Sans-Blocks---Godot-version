class_name Alien extends Enemy


var alienfile = FileAccess.get_file_as_string("res://Data/alien_colors.json")
var aliencolors = JSON.parse_string(alienfile)
var selectedcolors:Array

var aliensprites = ["res://Sprites/Alien/alienlight","res://Sprites/Alien/alienmain","res://Sprites/Alien/aliendark","res://Sprites/Alien/alienoutlinelight","res://Sprites/Alien/alienoutlinedark"]

var xSpeedModifier:int
var currentKill:int

var variant:int = randi_range(1,3)

var moveTimer:float = 1.0
var movedDown:bool = true

@onready var walkAudios = [$Fastinvader1,$Fastinvader2,$Fastinvader3,$Fastinvader4]
var walkiter:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtAudios = [$Invaderkilled]
	shoots = true
	sprites = [$Light,$Main,$Dark,$OutlineLight,$OutlineDark]
	mainSprite = sprites[0]
	enterValue = 32
	xSpeed = 1.0
	ySpeed = 0.0
	attacktimer = randi_range(250,500)
	projectilesource = preload("res://Objects/AlienLaser.tscn")
	currentKill = RuleManager.kill
	match variant:
		1:
			hp = 1
			dmg = 1
		2:
			hp = 2
			dmg = 1
			moveTimer *= 2
		3:
			hp = 1
			dmg = 2
	tier = 1
	dropChance = 2
	for i in range(len(sprites)):
		sprites[i].sprite_frames = SpriteFrames.new()
		Animator.new().createAnimation(sprites[i].sprite_frames,"idle",true,10.0)
		Animator.new().createFramesManual(aliensprites[i]+str(variant)+".png",sprites[i].sprite_frames,4,[0,1,2,1],[3,1,3,1],"idle")
		Animator.new().createAnimation(sprites[i].sprite_frames,"hurt",false,2.0)
		Animator.new().createFramesManual(aliensprites[i]+str(variant)+".png",sprites[i].sprite_frames,4,[3],[1],"hurt")
		sprites[i].play("idle")
	Animator.new().createAnimation(sprites[0].sprite_frames,"death",false,10.0)
	Animator.new().createFramesAuto("res://Sprites/Alien/alienexplosion.png",sprites[0].sprite_frames,4,"death")
	
	fromLorCorR = 1
	if randi_range(0,1):
		fromLorCorR *= -1
	fromYvalue = -540/(2*RuleManager.zoom) + 32 * randi_range(1, 4) + 4
	var x = fromLorCorR * (960/(2*RuleManager.zoom))
	var y = fromYvalue
	position = Vector2(x, y)
	xSpeed *= -fromLorCorR
	selectedcolors = selectColor(y)
	for i in range(len(sprites)):
		sprites[i].modulate = Color(selectedcolors[i])
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if hp > 0:
		super(delta)
		xSpeedModifier = RuleManager.kill - currentKill
		
		moveTimer -= delta * (xSpeedModifier/2.0 + 1)
		if moveTimer <= 0:
			walkAudios[walkiter%4].play()
			walkiter += 1
			moveTimer = 1.0 + int(variant == 2)
			if not movedDown and entered and abs(position.x) >= 960/(2*RuleManager.zoom) - 32:
				movedDown = true
				xSpeed *= -1
				position.y += 32
				selectedcolors = selectColor(position.y)
				for i in range(len(sprites)):
					sprites[i].modulate = Color(selectedcolors[i])
			else:
				movedDown = false
				position.x += xSpeed * 16

func selectColor(y:float)->Array:
	if y >= 36:
		return aliencolors[3]
	elif y >= 4:
		return aliencolors[2]
	elif y >= -12:
		return aliencolors[1]
	else:
		return aliencolors[0]

func _on_area_entered(area: Area2D) -> void:
	super(area)
	if area == Ball and mainSprite.animation != "death":
		if hp <= 0:
			mainSprite.play("death")
			if len(sprites) > 1:
				for i in range(1,len(sprites)):
					sprites[i].queue_free()
		else:
			for i in range(len(sprites)):
				sprites[i].play("hurt")


func shootProjectile()->void:
	projectileSpeed = 20
	super()
