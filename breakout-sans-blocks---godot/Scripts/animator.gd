class_name Animator

extends Node

var globalOldColors:Array[Color] = [Color("242424"),Color("555555"),Color("787878"),Color("c0c0c0"),Color("ffffff")]

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

func createFramesAutoTexture(tex:Texture2D,sprite:SpriteFrames,frames:int,animname:String)->void:
	var texwidth = tex.get_width() / frames
	var texheight = tex.get_height()
	for i in range(0,frames):
		var atlas = AtlasTexture.new()
		atlas.atlas = tex
		atlas.region = Rect2(texwidth * i, 0, texwidth, texheight)
		sprite.add_frame(animname,atlas,1.0)

func createFramesManualTexture(tex:Texture2D,sprite:SpriteFrames,originalframelen:int,frames:Array[int],durations:Array[float],animname:String)->void:
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

func applyColor(path:String,newColors:Array)->Texture2D:
	var img:Image = load(path).get_image()
	for y in img.get_height():
		for x in img.get_width():
			for i in range(len(newColors)):
				if img.get_pixel(x,y) == globalOldColors[i]:
					img.set_pixel(x,y,Color(newColors[i]))
	return ImageTexture.create_from_image(img)
	
func applyColortoOld(path:String,oldColors:Array[Color],newColors:Array)->Texture2D:
	var img:Image = load(path)
	for y in img.get_height():
		for x in img.get_width():
			for i in range(len(newColors)):
				if img.get_pixel(x,y) == oldColors[i]:
					img.set_pixel(x,y,Color(newColors[i]))
	return ImageTexture.create_from_image(img)
