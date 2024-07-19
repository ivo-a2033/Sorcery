extends Sprite2D


var held = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (get_global_mouse_position() - global_position).length() < 128:
		if Input.is_action_just_pressed("click"):
			held = true
	if Input.is_action_just_released("click"):
		held = false
		
	if held:
		global_position = get_global_mouse_position()
