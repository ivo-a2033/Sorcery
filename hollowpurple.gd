extends Node2D


var time = 12
var hitlist = []
var caster 
var casting_time = 1
var cast_effect = load("res://spell_cast.tscn")
var myeffect 

func _ready():
	$Area2D.connect("body_entered", listplus)
	$Area2D.connect("body_exited", listminus)
	var effect = cast_effect.instantiate()
	effect.position = position
	effect.emitting = true
	myeffect = effect
	get_parent().add_child(effect)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	Globals.lower_brightness_to(0)
	
	$PointLight2D.visible = not (casting_time > 0)
	if casting_time > 0:
		casting_time -= delta
	else:
		if weakref(myeffect).get_ref() != null:
			myeffect.queue_free()
			
		time -= delta
		$PointLight2D.texture_scale += (100 - $PointLight2D.texture_scale) * delta / 1
		$Area2D/CollisionShape2D.shape.radius += (500 - $Area2D/CollisionShape2D.shape.radius) * delta / 1
		$PointLight2D.rotate(delta * .15 * time/12)
		$PointLight2D.color = Color.from_hsv(.9 - time/120, 1, .7)
		
		for body in hitlist:
			body.take_dmg(1)
			
		if time <= 0:
			queue_free()

func listplus(body):
	if body.get("hp") != null and body != caster:
		hitlist.append(body)
		
func listminus(body):
	if body in hitlist:
		hitlist.remove_at(hitlist.find(body))
