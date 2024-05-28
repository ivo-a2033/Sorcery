extends RigidBody2D


var jump_force = 25000
var move_force = 1000
var hp = 100
var slash_scene = load("res://slash.tscn")
var flip_x = 1

var mov_dict = {
	"up": "w",
	"left": "a",
	"down": "s",
	"right": "d"
}

func _ready():
	if Globals.p1 == null:
		Globals.p1 = self
	else:
		Globals.p2 = self
		mov_dict = {
			"up": "up",
			"left": "left",
			"down": "down",
			"right": "right"
		}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ProgressBar.value = hp
	
	if Input.is_action_just_pressed(mov_dict["up"]):
		apply_central_force(Vector2(0,-1) * jump_force)
	if Input.is_action_pressed(mov_dict["left"]):
		apply_central_force(Vector2(-1,0) * move_force)
		flip_x = -1
	if Input.is_action_pressed(mov_dict["right"]):
		apply_central_force(Vector2(1,0) * move_force)
		flip_x = 1
		
	if Input.is_action_just_pressed(mov_dict["down"]):
		var slash = slash_scene.instantiate()
		slash.position = position
		slash.flip_x = flip_x
		slash.set_velocity()
		slash.exceptions.append(self)
		get_parent().add_child(slash)
