extends Node

var cheevo = load("res://Objects/cheevo.tscn")

var cheevoFile = FileAccess.get_file_as_string("res://Data/achievements.json")
var cheevoArray = JSON.parse_string(cheevoFile)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(cheevoArray[0])
	#print(typeof(cheevoArray[0][2]))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func unlockCheevo(index:int)->void:
	if cheevoArray[index][2]:
		pass
	else:
		var tmp = cheevo.instantiate()
		tmp.currentCheevo = index
		add_sibling.call_deferred(tmp)
