extends Node2D


var time = 3

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	get_parent().heal(delta * 5)
	
	time -= delta
	if time < 1:
		$SpellCast.emitting = false
		$PointLight2D.scale -= delta * Vector2(1,1)
	if time < 0:
		queue_free()
