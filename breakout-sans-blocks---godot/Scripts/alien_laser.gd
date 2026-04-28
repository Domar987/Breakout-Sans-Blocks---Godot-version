class_name AlienLaser extends Projectile

var alienfile = FileAccess.get_file_as_string("res://Data/alien_colors.json")
var aliencolors = JSON.parse_string(alienfile)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.y >= 36:
		modulate = aliencolors[3][0]
	elif position.y >= 4:
		modulate =  aliencolors[2][0]
	elif position.y >= -12:
		modulate =  aliencolors[1][0]
	else:
		modulate =  aliencolors[0][0]
