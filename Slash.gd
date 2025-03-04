extends Area2D

var damage = 8
var flip_x = 1
var velocity = Vector2(0,0)
var speed = 350
var exceptions = []

signal give_energy

func _ready():
	$AnimationPlayer.play("slash")
	connect("body_entered", hit_hp)

func set_velocity():
	velocity = Vector2(flip_x, 0) * speed
	if flip_x == -1:
		$Sprite2D.flip_h = true

func _process(delta):
	position += velocity * delta
	
	if not $AnimationPlayer.is_playing():
		queue_free()

func hit_hp(body):
	if body.get("hp") != null and not(body in exceptions):
		body.take_dmg(damage)
		body.recoil(position)
		emit_signal("give_energy", damage)
		queue_free()
