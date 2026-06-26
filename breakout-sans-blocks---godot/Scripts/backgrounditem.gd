class_name BackgroundItem extends Projectile

var bgsprites = ["bricks1","bricks2","bricks3","bricks4","bricks5",
				"grafitti","tunnelsmall","tunnelbig","pipesmall","pipebig"]

var parent
var fromTop:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	var tex:Texture2D
	$AnimatedSprite2D.sprite_frames = SpriteFrames.new()
	if fromTop:
		position.y = -540/(2*RuleManager.zoom) - 32
	else:
		position.y = randi_range(-540/(2*RuleManager.zoom),540/(2*RuleManager.zoom))
	
	var bgsprite = bgsprites[randi_range(0,len(bgsprites)-1)]
	var texforshape:Texture2D = load("res://Sprites/Background/bg"+bgsprite+".png")
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.size = Vector2(texforshape.get_width(),texforshape.get_height())
	if randi_range(0,1000) == 1000:
		bgsprite = "howdidthisgethere"
	else:
		tex = Animator.new().applyColor("res://Sprites/Background/bg"+bgsprite+".png",parent.currentcolors)
		if bgsprite == bgsprites[len(bgsprites)-1]:
			position.x = -960/(2*RuleManager.zoom) + randi_range(-32,8)
		else:
			position.x = randi_range(-960/(2*RuleManager.zoom),960/(2*RuleManager.zoom))
	Animator.new().createAnimation($AnimatedSprite2D.sprite_frames,"1",true,1.0)
	if bgsprite == "howdidthisgethere":
		Animator.new().createFramesAuto("res://Sprites/Background/"+bgsprite+".png",$AnimatedSprite2D.sprite_frames,1,"1")
	else:
		Animator.new().createFramesAutoTexture(tex,$AnimatedSprite2D.sprite_frames,1,"1")
	direction = Vector2.DOWN
	$AnimatedSprite2D.play("1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	speed = RuleManager.ySpeed
	#$Label.text = str(speed)+"\n"+str(delta)
	super(delta)

func _on_area_entered(area: Area2D) -> void:
	if area is BackgroundItem:
		parent.shootProjectile(true)
		queue_free()
