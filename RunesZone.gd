extends Area2D

@export var my_id = 0
var my_runes = null

func _ready():
	connect("area_entered", add_to_runes)
	connect("area_exited", remove_from_runes)
	
	if my_id == 0:
		my_runes = Globals.runes1
	else:
		my_runes = Globals.runes2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_to_runes(area):
	my_runes.append(area.get_parent().rune_name)

	
func remove_from_runes(area):
	if not Globals.has_started:
		my_runes.remove_at(my_runes.find(area.get_parent().rune_name))


