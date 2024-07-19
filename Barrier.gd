extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_exited", hurt_bad)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hurt_bad(body):
	if body.get("hp") != null:
		body.take_dmg(9999)
