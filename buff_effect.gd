extends Node2D


var time = 8 

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	time -= delta
	if time < 1:
		$SpellCast.emitting = false
		$PointLight2D.scale -= delta * Vector2(1,1)
	if time < 0:
		queue_free()
