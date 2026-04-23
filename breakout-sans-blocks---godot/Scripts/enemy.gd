class_name Enemy extends Area2D


@onready var RuleManager = $/root/Ingame/RuleManager
@onready var Ball = $/root/Ingame/Ball
@onready var Wall = $/root/Ingame/Wall
@onready var sprites:Array[AnimatedSprite2D]
var mainSprite:AnimatedSprite2D

var fromLorCorR:int
var fromYvalue:int
var xSpeed:float = 1.0
var entered:bool = false

var attacktimer:int
var hp:int
var dmg:int
var projectileSpeed:int
var projectilesource:PackedScene
var projectileTexturePath:String
var projectileBlastTexturePath:String
var projectileFrames:int
var projectileblastFrames:int

var attackTimerBase:int
var xSpeedOld:float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attackTimerBase = attacktimer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	attacktimer -= 1
	if attacktimer <= 0:
		shootProjectile()
		attacktimer = attackTimerBase
	
	if abs(position.x) < abs(get_viewport().size.x/(2*RuleManager.zoom)) - 2* Wall.wallwidth and !entered:
		entered = true


func _on_area_entered(area: Area2D) -> void:
	if area == Ball and mainSprite.animation != "death":
		hp -= 1
		xSpeedOld = xSpeed
		xSpeed = 0
		if hp <= 0:
			mainSprite.play("death")
		else:
			for i in range(len(sprites)):
				sprites[i].play("hurt")


func _on_animated_sprite_2d_animation_finished() -> void:
	if mainSprite.animation == "death":
		RuleManager.kill += 1
		queue_free()
	else:
		xSpeed = xSpeedOld
		for i in range(len(sprites)):
			sprites[i].play("idle")

func shootProjectile()->void:
	var projectile = projectilesource.instantiate()
	projectile.texturepath = projectileTexturePath
	projectile.blasttexturepath = projectileBlastTexturePath
	projectile.frames = projectileFrames
	projectile.blastframes = projectileblastFrames
	projectile.damage = dmg
	projectile.speed = projectileSpeed
	projectile.position = position
	projectile.modulate = mainSprite.modulate
	add_sibling(projectile)
