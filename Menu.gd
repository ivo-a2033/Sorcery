extends Control


var technique1 = "Black Hole"
var technique2 = "Black Hole"

var all_techniques = {
	0: "Black Hole",
	1: "Ghost Dogs",
}

func _ready():
	$Start.connect("button_down", start)
	var popup = $Technique1.get_popup()
	popup.connect("id_pressed", file_menu)
	popup = $Technique2.get_popup()
	popup.connect("id_pressed", file_menu2)

func file_menu(id):
	technique1 = all_techniques[id]

func file_menu2(id):
	technique2 = all_techniques[id]
	
func start():
	Globals.technique1 = technique1
	Globals.technique2 = technique2
	get_tree().change_scene_to_packed(load("res://world.tscn"))

func _process(delta):
	if Input.is_action_pressed("click"):
		$MenuBg.emit_signal("clicky")
	
	$Technique1.text = "Abnormal Technique:\n" + technique1
	$Technique2.text = "Abnormal Technique:\n" + technique2
	
