extends Area2D


var hit_list = []
var myForce = -100000

func _ready():
	connect("body_entered", add_to_hit_list)
	$AnimationPlayer.play("idle")


func _physics_process(delta):
	for body in hit_list:
		body.hp -= 60 * delta
	
	var vec = (Globals.p1.position - position)
	var force = myForce/vec.length()
	#Globals.p1.apply_central_force(vec.normalized() * force)
	
	vec = (Globals.p2.position - position)
	force = myForce/vec.length()
	#Globals.p2.apply_central_force(vec.normalized() * force)
	
func add_to_hit_list(body):
	if body.get("hp") != null:
		hit_list.append(body)
		
