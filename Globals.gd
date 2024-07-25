extends Node

var rng = RandomNumberGenerator.new()
var p1
var p2

var labels = []

var envoirment_brightness = 1
var world_canvas
var cam

var holding = null

var runes1 = []
var runes2 = []
var has_started = false


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if world_canvas != null:
		var v = int(envoirment_brightness * 255)
		var t = 200 + int(55 * envoirment_brightness)
		world_canvas.color = Color8(v,v,v,t)
	
	if Input.is_action_just_pressed("r"):
		runes1 = []
		runes2 = []
	
		var to_remove = []
		for label in labels:
			to_remove.append(label)
		for label in to_remove:
			label.queue_free()
		labels = []
		get_tree().change_scene_to_packed(load("res://menu.tscn"))
	
	var remove = []
	for label in labels:
		label.position.y -= delta * 25
		label.scale -= label.scale * .5 * delta
		if label.scale.x <= .1:
			remove.append(label)
		
	for label in remove:
		labels.remove_at(labels.find(label))
		label.queue_free()
		
	if envoirment_brightness < 1:
		envoirment_brightness += delta * .55                                               
	
func lower_brightness_to(n):
	if envoirment_brightness > n:
		envoirment_brightness += (n - envoirment_brightness) * 1/60.0 * 2
