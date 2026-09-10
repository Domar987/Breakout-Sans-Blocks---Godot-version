extends Control

var children:Array[Sprite2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(1,16):
		children.append(get_child(i))
	update(10)

func update(health:int)->void:
	if health < 0:
		health = 0
	if health <= 15:
		for i in range(0,health):
			children.get(i).frame = 0
		for i in range(health,len(children)):
			children.get(i).frame = 1
	else:
		modulate = Color.ORANGE * 2
		for i in range(0,len(children)):
			children.get(i).frame = 0
