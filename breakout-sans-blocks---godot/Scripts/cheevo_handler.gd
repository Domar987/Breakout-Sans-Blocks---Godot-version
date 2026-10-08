extends Node

var cheevo = load("res://Objects/cheevo.tscn")

var cheevoFile = FileAccess.get_file_as_string("res://Data/achievements.json")
var cheevoArray = JSON.parse_string(cheevoFile)


func unlockCheevo(index:int)->void:
	if cheevoArray[index][2]:
		pass
	else:
		cheevoArray[index][2] = true
		var cheevoUpdate = FileAccess.open("res://Data/achievements.json",FileAccess.WRITE)
		cheevoUpdate.store_string(JSON.stringify(cheevoArray,"\t"))
		var tmp = cheevo.instantiate()
		tmp.currentCheevo = index
		add_sibling.call_deferred(tmp)
