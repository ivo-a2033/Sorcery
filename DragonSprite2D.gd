extends Sprite2D


var phase = Globals.rng.randf_range(0,5)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale.x = sin(Engine.get_physics_frames()/20.0 + phase) * 1.5
