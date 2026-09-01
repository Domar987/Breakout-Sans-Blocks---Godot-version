class_name Particle extends Node2D

var vanishwhenfinish:bool = false
@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D

var importedSpeed = null
var speed:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tmp = sprite.sprite_frames.get_animation_names()
	sprite.play(tmp.get(randi_range(0,len(tmp)-1)))
	sprite.animation_finished.connect(_anim_finished)
	
	if importedSpeed != null:
		speed = importedSpeed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += speed * delta
	speedFormula(delta)

func speedFormula(delta: float)->void:
	pass

func _anim_finished()->void:
	if vanishwhenfinish:
		queue_free()
