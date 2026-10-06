extends TextureButton

@export var menuToLoad:Control
@export var activeAtlas:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed()->void:
	if toggle_mode:
		texture_normal.region.x = activeAtlas
	else:
		texture_normal.region.x = 0
