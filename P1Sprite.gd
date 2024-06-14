extends Sprite2D


var boss

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += (boss.position - position) * delta * 5
