extends Panel

@onready var buttons:Array[Button] = [get_child(2),get_child(3),get_child(4)]
var retryHovering:bool = false
var menuHovering:bool = false

@onready var retrytex = buttons[1].get_child(0)
@onready var retrytext = buttons[1].get_child(1)
@onready var menutex = buttons[2].get_child(0)
@onready var menutext = buttons[2].get_child(1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttons[0].pressed.connect(exitPressed)
	buttons[1].pressed.connect(retryPressed)
	buttons[2].pressed.connect(menuPressed)
	buttons[1].mouse_entered.connect(retryHover)
	buttons[2].mouse_entered.connect(menuHover)
	buttons[1].mouse_exited.connect(retryHovEnd)
	buttons[2].mouse_exited.connect(menuHovEnd)
	position = Vector2(100,-38)
	buttons[0].position = Vector2(-54,150)
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"position",Vector2(-78,-38),0.6)
	tween.tween_property(buttons[0],"position",Vector2(-54,105),0.5)
	tween.tween_callback(signanim)

func signanim()->void:
	buttons[0].get_child(0).play("default_1")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		retryPressed()
	if Input.is_key_pressed(KEY_M):
		menuPressed()
	
	retrytext.position.y = (1-retrytext.scale.x) * 8.5
	menutext.position.x = (1-menutext.scale.x) * 46
	menutext.position.y = (1-menutext.scale.x) * 14
	if retryHovering:
		if retrytex.position.x > 0:
			retrytex.position.x -= (4*retrytex.position.x + 12)*delta
		else:
			retrytex.position.x = 0
		if retrytext.scale.x < 1:
			retrytext.scale += 4 * Vector2.ONE * delta
		else:
			retrytext.scale = Vector2.ONE
	else:
		if retrytex.position.x < 24:
			retrytex.position.x += (108 - 4*retrytex.position.x)*delta
		else:
			retrytex.position.x = 24
		if retrytext.scale.x > 0.01:
			retrytext.scale -= 4 * Vector2.ONE * delta
		else:
			retrytext.scale = Vector2.ZERO
	
	if menuHovering:
		if menutex.position.x < 47:
			menutex.position.x += (108 - 4*(24.0/20)*(menutex.position.x - 27))*delta
		else:
			menutex.position.x = 47
		if menutext.scale.x < 1:
			menutext.scale += 3 * Vector2.ONE * delta
		else:
			menutext.scale = Vector2.ONE
	else:
		if menutex.position.x > 27:
			menutex.position.x -= (4*(24.0/20)*(menutex.position.x - 27) + 12)*delta
		else:
			menutex.position.x = 27
		if menutext.scale.x > 0.01:
			menutext.scale -= 3 * Vector2.ONE * delta
		else:
			menutext.scale = Vector2.ZERO


func exitPressed()->void:
	create_tween().tween_property($/root/Ingame,"modulate",Color.BLACK,0.8)
	await get_tree().create_timer(1).timeout
	get_tree().quit()

func retryPressed()->void:
	create_tween().tween_property($/root/Ingame,"modulate",Color.BLACK,0.8)
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()

func menuPressed()->void:
	create_tween().tween_property($/root/Ingame,"modulate",Color.BLACK,0.8)
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func retryHover()->void:
	retryHovering = true

func menuHover()->void:
	menuHovering = true

func retryHovEnd()->void:
	retryHovering = false

func menuHovEnd()->void:
	menuHovering = false
