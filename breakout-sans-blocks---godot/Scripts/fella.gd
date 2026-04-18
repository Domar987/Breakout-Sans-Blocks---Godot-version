extends TextureRect

var startsize = Vector2(700,350)
var startpos = Vector2(-21,90.2)
var targetsize = Vector2(70,35)
var targetpos = Vector2(-27,17)

# Called when the node enters the scene tree for the first time.
func fellaanimation() -> void:
	size = startsize
	position = startpos
	var tween = create_tween().set_trans(Tween.TRANS_SPRING).set_parallel(true)
	tween.tween_interval(0.5)
	tween.chain().tween_property(self,"size",targetsize,0.65)
	tween.tween_property(self,"position",targetpos,0.65)
