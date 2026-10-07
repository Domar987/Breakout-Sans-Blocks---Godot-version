extends HSlider

@export var indexToChange:int
var bus:int = -1

var label:Label
var labeltxt:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var fileString = FileAccess.get_file_as_string("res://Data/options.json")
	var fileArray = JSON.parse_string(fileString)
	drag_started.connect(startDrag)
	drag_ended.connect(endDrag)
	value = fileArray[indexToChange]
	if name == "Borders":
		label = get_child(0)
		labeltxt = label.text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bus >= 0:
		AudioServer.set_bus_volume_linear(bus,value/100.0)
	if label != null:
		label.text = labeltxt+"\n(x"+str(value * 0.1 + 1)+")  "

func startDrag()->void:
	match name:
		"Master":
			bus = 0
		"Music":
			bus = 1
		"Misc":
			bus = 2
		"Enemy":
			bus = 3
		"Annoying":
			bus = 4

func endDrag(value_changed:bool)->void:
	if value_changed:
		var fileString = FileAccess.get_file_as_string("res://Data/options.json")
		var fileArray = JSON.parse_string(fileString)
		fileArray[indexToChange] = value
		var fileUpdate = FileAccess.open("res://Data/options.json",FileAccess.WRITE)
		fileUpdate.store_string(JSON.stringify(fileArray,"\t"))
	bus = -1
