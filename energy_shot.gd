extends Area2D

@export var damage = 48
var flip_x = 1
var velocity = Vector2(0,0)
@export var speed = 350
var exceptions = []
var time = 15
@export var bouncy = true
@export var affect_lighting = true

signal give_energy

func _ready():
	connect("body_entered", hit_hp)
	
func set_velocity(vec):
	velocity = vec.normalized() * speed

func _process(delta):
	position += velocity * delta
	if affect_lighting:
		Globals.lower_brightness_to(.55 + (.45 * (position - Globals.cam.position).length()/2000))
	
	time -= delta
	if time <= 0:
		queue_free()

func hit_hp(body):
	if body.get("hp") != null and not(body in exceptions):
		body.take_dmg(damage)
		if bouncy:
			body.recoil(position)
		emit_signal("give_energy", damage)
		queue_free()
		
