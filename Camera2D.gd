extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.cam = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += ((Globals.p1.position + Globals.p2.position)*.5 - position) * delta * 5
	var zoom_ = 2/((Globals.p1.position - Globals.p2.position).length()/200)
	zoom_ = clamp(zoom_, .5, 2)
	
	zoom = Vector2(1,1) * zoom_
