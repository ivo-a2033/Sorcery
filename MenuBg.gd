extends Node2D


var rng
var all_polys = []
signal clicky
var push_force = 1000

func _ready():
	rng = Globals.rng
	
	for i in range(500):
		var points = []
		var origin = Vector2(rng.randi_range(0,1600), rng.randi_range(-200,900))
		var mysize = rng.randi_range(10,50)
		for j in range(3):
			points.append(origin + Vector2(mysize,0).rotated(j/3.0*PI*2 + rng.randf_range(0,PI)))
		var hue = .1
		var exact_hue = rng.randf_range(0,hue) + .4
		all_polys.append([points, Color.from_hsv(exact_hue, 1, 1), rng.randf_range(15,45), exact_hue, Vector2(0,0)])

	connect("clicky", push)

func _process(delta):
	for poly in all_polys:
		poly[4] *= .98
		
		#Vertical loop
		var return_up = false
		for i in range(3):
			var z = poly[2]
			poly[0][i] += Vector2(0, delta * z) + poly[4]
			if poly[0][i].y > 1100:
				return_up = true
		if return_up:
			for i in range(3):
				poly[0][i] += Vector2(0, -1300)
		
		#Horizontal loop
		if poly[0][0].x > 1600:
			for i in range(3):
				poly[0][i].x += -1600
		if poly[0][0].x < 0:
			for i in range(3):
				poly[0][i].x += 1600
			
	change_hue_slow()
	queue_redraw()

func push():
	for poly in all_polys:
		var vec = poly[0][0] - get_local_mouse_position()
		if vec.length() < 1600:
			for i in range(3):
				poly[4] += vec.normalized() * push_force / vec.length()
		
		

func change_hue_slow():
	var hue_change = .0001
	for poly in all_polys:
		var prev_hue = poly[3]
		poly[1] = Color.from_hsv(prev_hue + hue_change, 1, 1)
		poly[3] = prev_hue + hue_change
		
func _draw():
	for poly in all_polys:
		draw_colored_polygon(poly[0], poly[1])
