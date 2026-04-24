extends Node

@export var spawn:PackedScene
@export var spawnWeight:float
var timer:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	timer -= 1
	if timer <= 0:
		spawnEnemy()
		timer = randi_range(50, 200) / spawnWeight

func spawnEnemy()->void:
	var newSpawn = spawn.instantiate()
	add_sibling(newSpawn)
