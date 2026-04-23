extends Node2D

var buttons:Array
var mousePos:Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var startTween = create_tween().set_trans(Tween.TRANS_SPRING).set_parallel(true)
	modulate = Color.BLACK
	startTween.tween_property(self,"modulate",Color.WHITE,0.25)
	buttons = Array([], TYPE_OBJECT, "Node", Button)
	for child in get_child(1).get_children():
		if child is Button:
			var targetpos = child.position
			var startpos = Vector2(targetpos.x + 120, targetpos.y)
			child.position = startpos
			startTween.tween_property(child,"position",targetpos,0.5)
			child.pressed.connect(_button_pressed.bind(child))
			buttons.append(child)
	

func _process(_delta: float) -> void:
	mousePos = get_viewport().get_mouse_position() - Vector2(480,270)
	#$Label.text = str(get_viewport().get_mouse_position())+"\n"+ str(get_viewport().size / 2.0)+"\n"+ str(get_viewport().get_mouse_position() - get_viewport().size / 2.0)
	get_child(1).position = mousePos / 150.0
	get_child(2).position = -mousePos / 450.0
	get_child(3).position = -mousePos / 150.0

func _button_pressed(button):
	if button.name == "PlayButtonBig":
		$Miamiclick.play()
		$Miamiorchit.play()
		$TitleMusic.stop()
		var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_parallel(false)
		tween.tween_property(self,"modulate",Color.DIM_GRAY,0.4)
		tween.tween_property(self,"modulate",Color.WHITE,0.3)
		tween.tween_property(self,"modulate",Color.BLACK,1.2)
		tween.tween_property(self,"modulate",Color.BLACK,0.2)
		tween.tween_callback(changescene)
	elif button.name == "OptionsButton":
		pass
	elif button.name == "HowToPlayButton":
		var cont = button.get_child(1)
		if !cont.visible:
			cont.get_child(0).fellaanimation()
			cont.visible = true
	else:
		pass

func changescene()->void:
	get_tree().change_scene_to_file("res://Scenes/ingame.tscn")
