extends Node

var rng = RandomNumberGenerator.new()
var p1
var p2
var technique1
var technique2

var labels = []

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	var remove = []
	for label in labels:
		label.position.y -= delta * 25
		label.scale -= label.scale * .5 * delta
		if label.scale.x <= .1:
			remove.append(label)
		
	for label in remove:
		labels.remove_at(labels.find(label))
		label.queue_free()
