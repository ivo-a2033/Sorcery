extends Area2D


var velocity = Vector2(0,-256)
var pulling = null
var hand_closed = load("res://hand_closed.png")
var time = 20
var decay = 1

func _ready():
	connect("body_entered", grab)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time -= delta * decay
	
	position += velocity * delta
	if pulling != null:
		pulling.go(position, 1)
		
	if time <= 0:
		queue_free()
	
func grab(body):
	if body.get("hp") != null:
		pulling = body
		velocity.y = 256
		
		$Sprite2D.texture = hand_closed
	else:
		decay *= 15
