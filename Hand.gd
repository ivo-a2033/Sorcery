extends Area2D


var velocity = Vector2(0,-512)
var pulling = null
var hand_closed = load("res://hand_closed.png")
var time = 10
var decay = 1

var has_grabbed = false

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
	if body.get("hp") != null and not has_grabbed:
		pulling = body
		velocity.y = 32
		$Sprite2D.texture = hand_closed
		global_position = body.global_position
		
		has_grabbed = true

