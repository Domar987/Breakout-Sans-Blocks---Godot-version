extends StaticBody2D
var colShape1 = WorldBoundaryShape2D.new()
var colShape2 = WorldBoundaryShape2D.new()
var walltex = ImageTexture.create_from_image(Image.load_from_file("res://Sprites/wall.png"))
func _ready() -> void:
	colShape1.normal = Vector2(1,0)
	colShape2.normal = Vector2(-1,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	colShape1.distance = -get_viewport().size.x/(2*3) + 5
	colShape2.distance = -get_viewport().size.x/(2*3) + 5
	$CollisionShape2D1.shape = colShape1
	$CollisionShape2D2.shape = colShape2

func _draw() -> void:
	if $/root/Ingame/RuleManager.walls:
		for i in range(0,get_viewport().size.y/(4*3)):
			draw_texture(walltex,Vector2(-get_viewport().size.x/(2*3)-1,i*4-get_viewport().size.y/(2*3)))
			draw_texture(walltex,Vector2(get_viewport().size.x/(2*3)-5,i*4-get_viewport().size.y/(2*3)))
