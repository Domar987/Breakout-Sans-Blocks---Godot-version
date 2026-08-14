extends Panel

var clickable = true
var childToShow:int
var children:Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = Vector2(320,180)
	position = Vector2(-480,-90)
	children = get_children()
	for i in children:
		i.visible = false

func _input(event: InputEvent) -> void:
	if position == Vector2(-160,-90) and event is InputEventMouseButton:
		#var zoomedeventpos = (event.position / 3) - Vector2(160,90)
		##$Label.text = str(event.position)
		#if event is InputEventMouseButton and (zoomedeventpos.x < position.x or zoomedeventpos.x > position.x + 240 or zoomedeventpos.y < position.y or zoomedeventpos.y > position.y + 120):
			#disappear()
		var mousePos = get_viewport().get_mouse_position() - Vector2(480,270)
		if abs(mousePos.x) > 320 or abs(mousePos.y) > 160:
			disappear()

func appear(child:int)->void:
	if clickable:
		childToShow = child
		get_child(childToShow).visible = true
		clickable = false
		var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).set_parallel(false)
		tween.tween_property(self,"position",Vector2(-160,-90),0.5)
		tween.tween_property(self,"clickable",true,0.0)

func disappear()->void:
	if clickable:
		clickable = false
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).set_parallel(false)
		tween.tween_property(self,"position",Vector2(160,-90),0.5)
		tween.tween_property(self,"position",Vector2(-480,-90),0.0)
		tween.tween_property(self,"clickable",true,0.0)
		tween.tween_callback(killAllChildren)

func killAllChildren()->void:
	get_child(childToShow).visible = false
