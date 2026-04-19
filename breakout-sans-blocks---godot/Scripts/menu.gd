extends Node2D

var buttons:Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttons = Array([], TYPE_OBJECT, "Node", Button)
	for child in get_children():
		if child is Button:
			child.pressed.connect(_button_pressed.bind(child))
			buttons.append(child)

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
