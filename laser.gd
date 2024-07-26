extends Area2D


var caster = null
var hitlist = []
var time = 8


func _ready():
	connect("body_entered", listplus)
	connect("body_exited", listminus)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in hitlist:
		body.take_dmg(1)
	time -= delta
	if time <= 0:
		queue_free()
	
func listplus(body):
	if body.get("hp") != null and body != caster:
		hitlist.append(body)
		
func listminus(body):
	if body in hitlist:
		hitlist.remove_at(hitlist.find(body))
