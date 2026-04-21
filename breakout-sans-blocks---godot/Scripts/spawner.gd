extends Node

@export var spawn:PackedScene
@export var spawnWeight:int
var timer:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	timer -= 1
	if timer <= 0:
		spawnEnemy()
		timer = spawnWeight * randi_range(50, 200)
	pass

func spawnEnemy()->void:
	var newSpawn = spawn.instantiate()
	add_sibling(newSpawn)
