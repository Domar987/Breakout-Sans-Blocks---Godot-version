extends Enemy


var alienfile = FileAccess.get_file_as_string("res://Data/alien_colors.json")
var aliencolors = JSON.parse_string(alienfile)
var selectedcolors:Array

var aliensprites = ["res://Sprites/Alien/alienlight","res://Sprites/Alien/alienmain","res://Sprites/Alien/aliendark","res://Sprites/Alien/alienoutlinelight","res://Sprites/Alien/alienoutlinedark"]

var xSpeedModifier:int
var currentKill:int

var variant:int = randi_range(1,3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprites = [$Light,$Main,$Dark,$OutlineLight,$OutlineDark]
	mainSprite = sprites[0]
	xSpeed = 0.5
	attacktimer = randi_range(250,500)
	projectilesource = preload("res://Objects/Projectile.tscn")
	currentKill = RuleManager.kill
	match variant:
		1:
			hp = 1
			dmg = 1
		2:
			hp = 2
			dmg = 1
		3:
			hp = 1
			dmg = 2
	for i in range(0,5):
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
	fromYvalue = -get_viewport().size.y/(2*RuleManager.zoom) + 32 * randi_range(0, 4) + 4
	var x = fromLorCorR * (get_viewport().size.x/(2*RuleManager.zoom) + 11)
	var y = fromYvalue
	position = Vector2(x, y)
	xSpeed *= -fromLorCorR
	selectedcolors = selectColor(y)
	for i in range(0,5):
		sprites[i].modulate = Color(selectedcolors[i])
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	super(_delta)
	xSpeedModifier = RuleManager.kill - currentKill
	
	position.x += xSpeed * (1 + xSpeedModifier * (RuleManager.difficulty / 2) / 5.0)
	if entered and abs(position.x) >= abs(get_viewport().size.x/(2*RuleManager.zoom)) - 2 * Wall.wallwidth:
		xSpeed *= -1
		position.y += 32
		selectedcolors = selectColor(position.y)
		for i in range(0,5):
			sprites[i].modulate = Color(selectedcolors[i])


func _on_area_entered(area: Area2D) -> void:
	super(area)
	if hp <= 0:
		for i in range(1,len(sprites)):
			sprites[i].queue_free()

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
	var projectilevariant = randi_range(1,2)
	projectileTexturePath = "res://Sprites/Alien/alienprojectile"+str(projectilevariant)+".png"
	projectileBlastTexturePath = "res://Sprites/Alien/alienprojectileexplosion.png"
	projectileFrames = projectilevariant*2 + 2
	projectileblastFrames = 4
	projectileSpeed = 20
	super()
