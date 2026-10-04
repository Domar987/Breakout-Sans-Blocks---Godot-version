class_name BackgroundItem extends Projectile

var bgsprites = ["bricks1","bricks2","bricks3","bricks4","bricks5",
				"grafitti","tunnelsmall","tunnelbig","pipesmall","pipebig"]
var bgsprite
var parent

var special:int = 0

var relocateCounter:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tex:Texture2D
	$AnimatedSprite2D.sprite_frames = SpriteFrames.new()
	
	var texforshape:Texture2D
	if special == 0:
		var chance:int = randi_range(0,1000)
		if chance < 750:
			bgsprite = "bricks" + str(randi_range(1,5))
		elif chance < 800:
			bgsprite = "grafitti"
		elif chance <= 1000:
			bgsprite = "tunnel"
			if randi_range(0,1) == 1:
				bgsprite += "small"
			else:
				bgsprite += "big"
		texforshape = load("res://Sprites/Background/bg"+bgsprite+".png")
		tex = Animator.applyColor("res://Sprites/Background/bg"+bgsprite+".png",parent.currentcolors)
	elif special == 1:
		bgsprite = "pipe"
		if randi_range(0,1) == 1:
			bgsprite += "small"
		else:
			bgsprite += "big"
		texforshape = load("res://Sprites/Background/bg"+bgsprite+".png")
		tex = Animator.applyColor("res://Sprites/Background/bg"+bgsprite+".png",parent.currentcolors)
	else:
		bgsprite = "howdidthisgethere"
		texforshape = load("res://Sprites/Background/howdidthisgethere.png")
		scale.x = 1

	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.size = Vector2(texforshape.get_width(),texforshape.get_height())
	Animator.createAnimation($AnimatedSprite2D.sprite_frames,"1",true,1.0)
	if bgsprite == "howdidthisgethere":
		Animator.createFramesAuto("res://Sprites/Background/howdidthisgethere.png",$AnimatedSprite2D.sprite_frames,1,"1")
	else:
		Animator.createFramesAutoTexture(tex,$AnimatedSprite2D.sprite_frames,1,"1")
		if bgsprite == "grafitti":
			scale.x = 1
	direction = Vector2.DOWN
	
	$AnimatedSprite2D.play("1")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	speed = RuleManager.ySpeed
	super(delta)
