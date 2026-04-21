class_name Animator

extends Node

func createAnimation(sprite:SpriteFrames,name:String,loop:bool,speed:float)->void:
	sprite.add_animation(name)
	sprite.set_animation_loop(name,loop)
	sprite.set_animation_speed(name,speed)

func createFrames(path:String,sprite:SpriteFrames,frames:int,name:String)->void:
	var tex = load(path)
	var texwidth = tex.get_width() / frames
	var texheight = tex.get_height()
	for i in range(0,frames):
		var atlas = AtlasTexture.new()
		atlas.atlas = tex
		atlas.region = Rect2(texwidth * i, 0, texwidth, texheight)
		sprite.add_frame(name,atlas,1.0)

func createFramesManual(path:String,sprite:SpriteFrames,frames:Array[int],name:String)->void:
	var tex = load(path)
	var texwidth = tex.get_width() / frames
	var texheight = tex.get_height()
	for i in frames:
		var atlas = AtlasTexture.new()
		atlas.atlas = tex
		atlas.region = Rect2(texwidth * i, 0, texwidth, texheight)
		sprite.add_frame(name,atlas,1.0)
