class_name Enemy extends Area2D

var spawner:Spawner

var isRare:bool = false

@onready var RuleManager = $/root/Ingame/RuleManager
@onready var Ball = $/root/Ingame/Ball
@onready var Wall = $/root/Ingame/Wall
@onready var sprites:Array[AnimatedSprite2D]
var mainSprite:AnimatedSprite2D

var hurtAudios:Array[AudioStreamPlayer]

var fromLorCorR:int
var fromYvalue:int
var xSpeed:float = 1.0
var ySpeed:float = 1.0
var enterValue:int
var entered:bool = false

var attacktimer:int = 1
var hp:int
var dmg:int
var tier:int = 1
var dropChance:int = 0
var projectileSpeed:int
var projectilesource:PackedScene
var projectileTexturePath:String
var projectileBlastTexturePath:String
var projectileFrames:int
var projectileblastFrames:int
var projectilePosition = null

var attackTimerBase:int
var xSpeedOld:float
var ySpeedOld:float

var shoots:bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attackTimerBase = attacktimer
	mainSprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	area_entered.connect(_on_area_entered)
	area_exited.connect(areaExited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if hp > 0:
		if shoots:
			attacktimer -= 1
			if attacktimer <= 0:
				shootProjectile()
				attacktimer = attackTimerBase
		
		if abs(position.x) < abs(960/(2*RuleManager.zoom)) - enterValue and !entered:
			entered = true


func _on_area_entered(area: Area2D) -> void:
	if area == Ball and mainSprite.animation != "death":
		if area.position.y < position.y:
			ballFromTop()
		else:
			ballFromBottom()

func ballFromTop()->void:
	print(name+" hit from above")
	Ball.velocity.y = min(-125.28,Ball.velocity.y)
	getHurt()
func ballFromBottom()->void:
	print(name+" hit from below")
	getHurt()
func getHurt()->void:
	if len(hurtAudios) > 0:
		var audio = hurtAudios.pick_random()
		audio.pitch_scale = randf_range(0.9,1.0)
		audio.play()
	hp -= RuleManager.damage
	xSpeedOld = xSpeed
	xSpeed = 0
	ySpeedOld = ySpeed
	ySpeed = 0

func areaExited(area:Area2D)->void:
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	if mainSprite.animation == "death":
		Death()
	else:
		xSpeed = xSpeedOld
		ySpeed = ySpeedOld
		for i in range(len(sprites)):
			sprites[i].play("idle")

func shootProjectile()->void:
	var projectile = projectilesource.instantiate()
	#projectile.texturepath = projectileTexturePath
	#projectile.blasttexturepath = projectileBlastTexturePath
	#projectile.frames = projectileFrames
	#projectile.blastframes = projectileblastFrames
	projectile.damage = dmg
	projectile.speed = projectileSpeed
	projectile.position = position
	if projectilePosition != null:
		projectile.position = projectilePosition
	projectile.scale = scale
	add_sibling.call_deferred(projectile)

func Death()->void:
	RuleManager.kill += 1
	if randi_range(0,100) < dropChance:
		var projectile = load("res://Objects/Drop.tscn").instantiate()
		projectile.position = position
		projectile.speed = 10
		projectile.tier = tier
		add_sibling.call_deferred(projectile)
	remove()

func remove()->void:
	if spawner != null:
		spawner.numberOfEnemies -= 1
		if isRare:
			spawner.canSpawnRare = true
	queue_free()
