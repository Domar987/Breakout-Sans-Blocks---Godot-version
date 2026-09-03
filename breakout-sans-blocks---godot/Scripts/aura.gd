extends Node2D

var duration:int
var color:Color = Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = color
	scale = Vector2.ZERO
	tw()

func tw()->void:
	var oomphed = Color(color.r*3,color.g*3,color.b*3)
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2.ONE,0.25)
	tween.tween_interval(duration - 2)
	tween.tween_property(self,"modulate",Color(color,0.5),0.25)
	tween.tween_property(self,"modulate",Color(oomphed,0.9),0.25)
	tween.tween_property(self,"modulate",Color(color,0.3),0.25)
	tween.tween_property(self,"modulate",Color(oomphed,0.7),0.25)
	tween.tween_property(self,"modulate",Color(color,0.2),0.25)
	tween.tween_property(self,"modulate",Color(oomphed,0.5),0.25)
	tween.tween_property(self,"modulate",Color(color,0),0.25)
	tween.tween_callback(remove)

func remove()->void:
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(modulate)
	pass
