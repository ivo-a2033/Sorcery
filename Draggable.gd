extends Sprite2D


var held = false
@export var rune_name = "null"

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (get_global_mouse_position() - global_position).length() < 128 and Globals.holding == null:
		$Label.visible = Input.is_action_pressed("click")
		if Input.is_action_just_pressed("click"):
			held = true
			Globals.holding = self

		
	if Input.is_action_just_released("click"):
		held = false
		Globals.holding = null
			
	if held:
		global_position = get_global_mouse_position()
