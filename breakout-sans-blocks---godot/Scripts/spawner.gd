class_name Spawner extends Node

@export var spawn:PackedScene
@export var spawnWeight:float
@export var spawnAtDifficulty:int
@export var maxSpawned:int
@onready var ruleManager = $/root/Ingame/RuleManager
@onready var background = $/root/Ingame/Background
var numberOfEnemies:int = 0
var timer:int
@export var spawnRare:PackedScene
var canSpawnRare:bool = true
@export var rareChance:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = randi_range(min(50,int(50 / spawnWeight)), int(200 / spawnWeight))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if ruleManager.difficulty >= spawnAtDifficulty and numberOfEnemies < maxSpawned and ruleManager.health > 0:
		timer -= 1
		if timer <= 0:
			if spawnRare != null and canSpawnRare and randi_range(0,100) <= rareChance:
				spawnEnemy(spawnRare)
				canSpawnRare = false
			else:
				spawnEnemy(spawn)
			if spawnWeight > 0:
				timer = randi_range(min(50,int(50 / spawnWeight)), int(200 / spawnWeight))

func spawnEnemy(_spawn:PackedScene)->void:
	var newSpawn = _spawn.instantiate()
	newSpawn.name = newSpawn.name + str(numberOfEnemies)
	newSpawn.spawner = self
	add_sibling(newSpawn)
	numberOfEnemies += 1
