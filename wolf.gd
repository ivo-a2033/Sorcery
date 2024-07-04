extends Node2D


var target 
var velocity = Vector2(0,0)
var time = 8
var speed = 1200
var damage = 20


func _ready():
	$Area2D.connect("body_entered", hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vec = (target.position - position)
	velocity += vec.normalized() * delta * speed
	position += velocity * delta
	velocity -= velocity * .99 * delta * 2
	
	$Sprite2D.flip_h = velocity.x < 0

	time -= delta
	if time <= 0:
		queue_free()
		
		
func hit(body):
	if body == target:
		body.take_dmg(damage)
		queue_free()
