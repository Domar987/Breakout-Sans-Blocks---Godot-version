extends AudioStreamPlayer

var str = "res://Audio/Music/Ingame"

var dir = DirAccess.open(str)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tmp = dir.get_files()
	var list:Array[String]
	#for file in list:
		#print(file.right(6))
		#if file.right(6) == "import":
			#list.erase(file)
	for i in range(0,len(tmp),2):
		list.append(tmp[i])
	#print(list)
	stream = load(str+"/"+list[randi_range(0,len(list)-1)])
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
