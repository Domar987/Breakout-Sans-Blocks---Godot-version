class_name BackgroundItem extends Projectile

var bgsprites = ["bricks1","bricks2","bricks3","bricks4","bricks5",
				"grafitti","tunnelsmall","tunnelbig","pipesmall","pipebig"]

var parent
var fromTop:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tex:Texture2D
	$AnimatedSprite2D.sprite_frames = SpriteFrames.new()
	if fromTop:
		position.y = -540/(2*RuleManager.zoom) - 32
	else:
		position.y = randi_range(-540/(2*RuleManager.zoom),540/(2*RuleManager.zoom))
	
	var bgsprite = bgsprites[randi_range(0,len(bgsprites)-1)]
	if randi_range(0,1000) == 1000:
		bgsprite = "howdidthisgethere"
	else:
		tex = Animator.new().applyColor("res://Sprites/bg"+bgsprite+".png",parent.currentcolors)
		if bgsprite == bgsprites[len(bgsprites)-1]:
			position.x = -960/(2*RuleManager.zoom) + randi_range(-32,8)
		else:
			position.x = randi_range(-960/(2*RuleManager.zoom),960/(2*RuleManager.zoom))
	Animator.new().createAnimation($AnimatedSprite2D.sprite_frames,"1",true,1.0)
	if bgsprite == "howdidthisgethere":
		Animator.new().createFramesAuto("res://Sprites/"+bgsprite+".png",$AnimatedSprite2D.sprite_frames,1,"1")
	else:
		Animator.new().createFramesAutoTexture(tex,$AnimatedSprite2D.sprite_frames,1,"1")
	direction = Vector2.DOWN
	$AnimatedSprite2D.play("1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	speed = parent.ySpeed
	super(delta)
