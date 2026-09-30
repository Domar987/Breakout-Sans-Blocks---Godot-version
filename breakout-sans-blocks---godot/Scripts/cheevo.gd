class_name Cheevo extends TextureRect

@onready var sprite = $Sprite2D

var currentCheevo:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(-26,42)
	sprite.position = Vector2(32,32)
	sprite.frame = currentCheevo
	var tween = create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_interval(1.0)
	tween.tween_property(self,"position",Vector2(-26,-44),0.4)
	tween.parallel().tween_property(sprite,"position",Vector2(32,50),0.5)
	tween.tween_interval(2.5)
	tween.tween_property(self,"position",Vector2(-26,42),0.4)
	tween.parallel().tween_property(sprite,"position",Vector2(32,32),0.4)
	tween.tween_callback(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
