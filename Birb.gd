extends RigidBody2D


var smallshotscene = load("res://energy_shot_Small.tscn")
var power_level = 1
var enemy
var caster
var firerate = 3.0

var fire_timer = 0
var speed = 300

var hp = 100
var label_settings = load("res://new_label_settings.tres")

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.frame = 1 + int(Engine.get_physics_frames()/15)%2
	$Sprite2D.flip_h = (enemy.position.x < position.x)
	
	var vec = enemy.position - position
	if vec.length() > 256:
		apply_central_force(vec.normalized() * speed)

		
	fire_timer += delta
	if fire_timer > 1/firerate:
		fire_timer = 0
		var shot = smallshotscene.instantiate()
		shot.power_level = power_level
		shot.position = position
		shot.set_velocity((enemy.position - position).rotated(Globals.rng.randf_range(-.2,.2)))
		shot.exceptions.append(self)
		shot.exceptions.append(caster)
		get_parent().add_child(shot)
		
	if hp <= 0:
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
	apply_central_force(vec.normalized() * 20000)

func big_recoil(pos):
	var vec = (position - pos)
	apply_central_force(vec.normalized() * 80000)
