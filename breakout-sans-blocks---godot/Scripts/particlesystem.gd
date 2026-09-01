class_name ParticleSystem extends Node


var emit = func(particles:Array[PackedScene],count:int,position:Vector2):
	for i in range(0,count):
		var particle = particles.get(randi_range(0,len(particles)-1)).instantiate()
		particle.position = position
		add_sibling.call_deferred(particle)
	
var emitWithSpeed = func(particles:Array[PackedScene],count:int,position:Vector2,speed:Vector2):
	for i in range(0,count):
		var particle = particles.get(randi_range(0,len(particles)-1)).instantiate()
		particle.position = position
		particle.importedSpeed = speed
		add_sibling.call_deferred(particle)
