extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		i.recoil_modified()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_child_count() == 0:
		queue_free()
		print("Bye")
