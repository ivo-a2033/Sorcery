extends Area2D

var damage = 48
var flip_x = 1
var velocity = Vector2(0,0)
var speed = 350
var exceptions = []
var time = 15

signal give_energy

func _ready():
	connect("body_entered", hit_hp)
	
func set_velocity():
	velocity = Vector2(flip_x, 0) * speed

func _process(delta):
	position += velocity * delta
	Globals.envoirment_brightness = .55 + (.45 * (position - Globals.cam.position).length()/2000)
	
	time -= delta
	if time <= 0:
		queue_free()

func hit_hp(body):
	if body.get("hp") != null and not(body in exceptions):
		body.take_dmg(damage)
		body.recoil(position)
		emit_signal("give_energy", damage)
		queue_free()
