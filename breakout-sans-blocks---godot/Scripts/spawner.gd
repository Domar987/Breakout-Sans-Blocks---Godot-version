extends Node

@export var spawn:PackedScene
@export var spawnWeight:float
@export var spawnAtDifficulty:int
@export var maxSpawned:int
@onready var RuleManager = $/root/Ingame/RuleManager
var timer:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if RuleManager.difficulty >= spawnAtDifficulty:
		timer -= 1
		if timer <= 0:
			spawnEnemy()
			if spawnWeight > 0:
				timer = randi_range(50, 200) / spawnWeight

func spawnEnemy()->void:
	var newSpawn = spawn.instantiate()
	add_sibling(newSpawn)
