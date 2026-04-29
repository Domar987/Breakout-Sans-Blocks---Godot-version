class_name AlienLaser extends Projectile

var alienfile = FileAccess.get_file_as_string("res://Data/alien_colors.json")
var aliencolors = JSON.parse_string(alienfile)
var variant:int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	variant = randi_range(1,2)
	sprite.play(str(variant))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)
	if position.y >= 36:
		modulate = aliencolors[3][0]
	elif position.y >= 4:
		modulate =  aliencolors[2][0]
	elif position.y >= -12:
		modulate =  aliencolors[1][0]
	else:
		modulate =  aliencolors[0][0]
