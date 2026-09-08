class_name Spawner extends Node

@export var spawn:PackedScene
@export var spawnWeight:Array[float]
#@export var spawnAtDifficulty:int
@export var spawnAtLevels:Array[int]
@export var maxSpawned:Array[int]
@onready var RuleManager = $/root/Ingame/RuleManager
@onready var background = $/root/Ingame/Background
var numberOfEnemies:int = 0
var timer:float
@export var spawnRare:PackedScene
var canSpawnRare:bool = true
@export var rareChance:int = 0

@export var rareDelay:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = randf_range(min(0.8,0.8 / spawnWeight[0]), 3.2 / spawnWeight[0])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if RuleManager.level in spawnAtLevels and numberOfEnemies < maxSpawned[spawnAtLevels.find(RuleManager.level)] and RuleManager.health > 0:
		timer -= delta
		if timer <= 0:
			if spawnRare != null and RuleManager.level > rareDelay and canSpawnRare and randi_range(0,100) <= rareChance:
				spawnEnemy(spawnRare)
				canSpawnRare = false
			else:
				spawnEnemy(spawn)
			var currentWeight = spawnWeight[spawnAtLevels.find(RuleManager.level)]
			if currentWeight > 0:
				timer = randf_range(min(0.8,0.8 / currentWeight), 3.2 / currentWeight)

func spawnEnemy(_spawn:PackedScene)->void:
	var newSpawn = _spawn.instantiate()
	newSpawn.name = newSpawn.name + str(numberOfEnemies)
	newSpawn.spawner = self
	add_sibling(newSpawn)
	numberOfEnemies += 1
