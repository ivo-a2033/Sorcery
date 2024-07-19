extends RigidBody2D


var hp = 2500
var label_settings = load("res://new_label_settings.tres")

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hp -= 2500 * delta * 1/1000.0
	if hp < 0:
		queue_free()
		
		
func take_dmg(dmg):
	hp -= dmg
	var label = Label.new()
	label.label_settings = label_settings
	label.text = "-" + str(dmg)
	label.position = position + Vector2(Globals.rng.randf_range(0,64), 0).rotated(Globals.rng.randf_range(0, PI * 2))
	get_parent().add_child(label)
	Globals.labels.append(label)
	
func recoil(pos):
	var vec = (position - pos)
	apply_central_force(vec.normalized() * 1000000)
