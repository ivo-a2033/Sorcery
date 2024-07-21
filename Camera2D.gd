extends Camera2D



var sleep = 0
var pan_target = null
var zoom_ = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.cam = self
	Globals.p1.connect("blackhole_cast", pan_to_player)
	Globals.p2.connect("blackhole_cast", pan_to_player)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sleep > 0:
		position += (pan_target.position - position) * delta * 2
		zoom_ += (1.5 - zoom_) * delta * 2
		sleep -= delta
	else:
		position += ((Globals.p1.position + Globals.p2.position)*.5 - position) * delta * 5
		zoom_ = 2/((Globals.p1.position - Globals.p2.position).length()/200)
		zoom_ = clamp(zoom_, .95, 2)
		
	zoom = Vector2(1,1) * zoom_
	
	$AllCastCodes.visible = Input.is_action_pressed("esc")

func pan_to_player(p):
	sleep = 2
	pan_target = p

