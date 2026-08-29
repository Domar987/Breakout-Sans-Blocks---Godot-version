extends Node2D

var buttons:Array
var mousePos:Vector2
@onready var miniMenu = $MiniMenu
@onready var titleMusic:AudioStreamPlayer = $TitleMusic
@onready var effectP = $EffectParent
@onready var effect = $EffectParent/Effect
@onready var effect2 = $EffectParent/Effect2
var startedTitleEffect:bool = false
var effectSine:float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var startTween = create_tween().set_trans(Tween.TRANS_SPRING).set_parallel(true)
	modulate = Color.BLACK
	startTween.tween_property(self,"modulate",Color.WHITE,0.25)
	buttons = Array([], TYPE_OBJECT, "Node", Button)
	for i in range(1,4):
		for child in get_child(i).get_children():
			if child is Button:
				var targetpos = child.position
				var startpos = Vector2(targetpos.x + 120, targetpos.y)
				child.position = startpos
				startTween.tween_property(child,"position",targetpos,0.5)
				child.pressed.connect(_button_pressed.bind(child))
				buttons.append(child)
	

func _process(delta: float) -> void:
	mousePos = get_viewport().get_mouse_position() - Vector2(480,270)
	#$Label.text = str(get_viewport().get_mouse_position())+"\n"+ str(get_viewport().size / 2.0)+"\n"+ str(get_viewport().get_mouse_position() - get_viewport().size / 2.0)
	$RightSide.position = mousePos / 150.0
	$Centerish.position = -mousePos / 450.0
	$LeftSide.position = -mousePos / 150.0
	
	titleEffect()
	if startedTitleEffect:
		effectSine += 1.5 * delta
		var sine = sin(effectSine)/6.0 + 0.65
		effect.modulate.a = sine
		effect2.modulate.a = sine

func _button_pressed(button):
	match button.name:
		"PlayButtonBig":
			$Miamiclick.play()
			$Miamiorchit.play()
			$TitleMusic.stop()
			var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_parallel(false)
			tween.tween_property(self,"modulate",Color.DIM_GRAY,0.4)
			tween.tween_property(self,"modulate",Color.WHITE,0.3)
			tween.tween_property(self,"modulate",Color.BLACK,1.2)
			tween.tween_property(self,"modulate",Color.BLACK,0.2)
			tween.tween_callback(changescene)
		"OptionsButton":
			miniMenu.appear(1)
		"HowToPlayButton":
			var cont = button.get_child(1)
			if !cont.visible:
				cont.get_child(0).fellaanimation()
				cont.visible = true
		"Enemy":
			miniMenu.appear(0)

func changescene()->void:
	get_tree().change_scene_to_file("res://Scenes/ingame.tscn")

func titleEffect()->void:
	if titleMusic.get_playback_position() >= 20.533 and titleMusic.get_playback_position() < 47.870 and not startedTitleEffect:
		startedTitleEffect = true
		effectSine = 0.0
		var tween = create_tween().set_parallel(false)
		tween.tween_property(self,"modulate",Color(10,10,10,1),0.1)
		tween.tween_property(self,"modulate",Color.WHITE,0.2)
		effect.visible = true
		effect2.visible = true
		effectP.position = Vector2(0,80)
		create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property(effectP,"position",Vector2.ZERO,0.5)
		tweenPos()
	if titleMusic.get_playback_position() >= 47.870 and startedTitleEffect:
		startedTitleEffect = false
		var tween = create_tween().set_parallel(false)
		tween.tween_property(self,"modulate",Color(10,10,10,1),0.1)
		tween.tween_callback(boolstuf)
		tween.tween_property(self,"modulate",Color.WHITE,0.2)

func boolstuf()->void:
	effect.visible = false
	effect2.visible = false

func tweenPos()->void:
	effect.position = Vector2(0,47)
	effect2.position = Vector2(-320,47)
	var tween = create_tween().set_parallel(true)
	tween.tween_property(effect,"position",Vector2(320,47),4.5)
	tween.tween_property(effect2,"position",Vector2(0,47),4.5)
	if effect.visible:
		tween.tween_callback(tweenPos).set_delay(4.5)
