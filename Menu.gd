extends Control


func _ready():
	$Start.connect("button_down", start)

	
func start():
	Globals.labels = []

	Globals.has_started = true
	get_tree().change_scene_to_packed(load("res://world.tscn"))

	
func _process(delta):
	if Input.is_action_pressed("click"):
		$MenuBg.emit_signal("clicky")
