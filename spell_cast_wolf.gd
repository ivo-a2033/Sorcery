extends GPUParticles2D

var time = 1
signal spawn_dog

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time -= delta
	if time <= 0:
		emit_signal("spawn_dog", position)
		queue_free()
