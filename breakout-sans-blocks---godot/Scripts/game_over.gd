extends Panel

@onready var buttons:Array[Button] = [get_child(2),get_child(3),get_child(4)]
var retryHovering:bool = false
var menuHovering:bool = false

@onready var retrytex = buttons[1].get_child(0)
#@onready var retry = buttons[1].get_child(1)
@onready var menutex = buttons[2].get_child(0)
#@onready var menu = buttons[2].get_child(1)

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
	if retryHovering:
		if retrytex.position.x > 0:
			retrytex.position.x -= (4*retrytex.position.x + 12)*delta
		else:
			retrytex.position.x = 0
	else:
		if retrytex.position.x < 24:
			retrytex.position.x += (108 - 4*retrytex.position.x)*delta
		else:
			retrytex.position.x = 24
	
	if not menuHovering:
		if menutex.position.x > 27:
			menutex.position.x -= (4*(24.0/20)*(menutex.position.x - 27) + 12)*delta
		else:
			menutex.position.x = 27
	else:
		if menutex.position.x < 47:
			menutex.position.x += (108 - 4*(24.0/20)*(menutex.position.x - 27))*delta
		else:
			menutex.position.x = 47


func exitPressed()->void:
	pass

func retryPressed()->void:
	pass

func menuPressed()->void:
	pass

func retryHover()->void:
	retryHovering = true

func menuHover()->void:
	menuHovering = true

func retryHovEnd()->void:
	retryHovering = false

func menuHovEnd()->void:
	menuHovering = false
