extends RigidBody2D


var broken = false
var last_velocity = Vector2(0,0)
var brokenegg = load("res://birdeggbroken.png")
var breaking_point = 100

var time = 5
var birbscene = load("res://birb.tscn")

var enemy
var caster

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var accel = (linear_velocity - last_velocity).length()
	print(accel)
	if accel > breaking_point:
		broken = true
		$Sprite2D.texture = brokenegg
		
	last_velocity = linear_velocity
	
	time -= delta
	if time <= 0:
		if not broken:
			var my_birb = birbscene.instantiate()
			my_birb.global_position = global_position
			my_birb.enemy = enemy
			my_birb.caster = caster
			get_parent().add_child(my_birb)
		queue_free()
