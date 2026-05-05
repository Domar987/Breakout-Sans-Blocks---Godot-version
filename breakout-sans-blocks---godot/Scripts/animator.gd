class_name Animator

extends Node

func createAnimation(sprite:SpriteFrames,animname:String,loop:bool,speed:float)->void:
	sprite.add_animation(animname)
	sprite.set_animation_loop(animname,loop)
	sprite.set_animation_speed(animname,speed)

func createFramesAuto(path:String,sprite:SpriteFrames,frames:int,animname:String)->void:
	var tex = load(path)
	var texwidth = tex.get_width() / frames
	var texheight = tex.get_height()
	for i in range(0,frames):
		var atlas = AtlasTexture.new()
		atlas.atlas = tex
		atlas.region = Rect2(texwidth * i, 0, texwidth, texheight)
		sprite.add_frame(animname,atlas,1.0)

func createFramesManual(path:String,sprite:SpriteFrames,originalframelen:int,frames:Array[int],durations:Array[float],animname:String)->void:
	var tex = load(path)
	var texwidth = tex.get_width() / originalframelen
	var texheight = tex.get_height()
	for i in range(0,len(frames)):
		var atlas = AtlasTexture.new()
		atlas.atlas = tex
		atlas.region = Rect2(texwidth * frames[i], 0, texwidth, texheight)
		sprite.add_frame(animname,atlas,durations[i])

func chooseTexture(path:String,frames:int,targetframe:int)->Texture2D:
	var tex = load(path)
	var texwidth = tex.get_width() / frames
	var texheight = tex.get_height()
	var atlas = AtlasTexture.new()
	atlas.atlas = tex
	atlas.region = Rect2(texwidth * targetframe, 0, texwidth, texheight)
	return atlas
