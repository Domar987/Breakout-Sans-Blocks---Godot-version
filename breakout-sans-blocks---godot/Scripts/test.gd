extends Node

var list = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0,1000):
		list.append(randi_range(0,100))
	list.sort()
	var last = list[0]
	for i in range(0,1000):
		if list[i] != last:
			last = list[i]
			$Label.text += "\n"
		$Label.text += str(list[i]) + " "


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
