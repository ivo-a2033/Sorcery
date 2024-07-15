extends RigidBody2D


var jump_force = 25000
var move_force = 500
var hp = 100
var slash_scene = load("res://slash.tscn")
var flip_x = 1
var ammo = 3

var technique = null
var cursed_energy = 100

var mov_dict = {
	"up": "w",
	"left": "a",
	"down": "s",
	"right": "d",
	"cast": "space"
}

var blackhole = load("res://blackhole.tscn")
var ghostdogsscene = load("res://wolf.tscn")
var ghostdogsscenespawner = load("res://spell_cast_wolf.tscn")
var shotscene = load("res://energy_shot.tscn")
var hollowpurple = load("res://hollowpurple.tscn")
var smallshotscene = load("res://energy_shot_Small.tscn")

var enemy 
signal give_energy

var idle_texture = load("res://guy.png")
var cast_texture = load("res://guy_arms_up.png")
var cast_time = 0

var damage_texture = load("res://guy_flipped.png")
var damage_time = 0

signal blackhole_cast

var cast_code = ""
var code_to_spell = {
	"00110101101": "Black Hole",
	"11011": "Ghost Dogs",
	"10110": "Energy Shot",
	"0110111010100100101": "Hollow Purple",
	"0101000010101010100": "Energy Shot Small",

}
var cast_codes = code_to_spell.keys()

var binary_nodes = []
var nodes_phase = 0

var symbols = {
	0: load("res://zero_symbol.png"),
	1: load("res://one_symbol.png")
}


func _ready():
	if Globals.p1 == null:
		Globals.p1 = self
		technique = Globals.technique1
	else:
		Globals.p2 = self
		enemy = Globals.p1
		
		enemy.connect("give_energy", get_energy)
		connect("give_energy", enemy.get_energy)
		
		Globals.p1.enemy = self
		
		technique = Globals.technique2
		mov_dict = {
			"up": "up",
			"left": "left",
			"down": "down",
			"right": "right",
			"cast": "l"
		}
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	nodes_phase += delta * 5
	manage_nodes()
	
	
	$UI/HP.value = hp
	$UI/Ammo.value = ammo/3.0*100
	$UI/Energy.value = cursed_energy	

	cursed_energy += delta * 3
		

	if cast_time > 0:
		cast_time -= delta
		$Sprite2D.texture = cast_texture
		if cast_time <= 0:
			$Sprite2D.texture = idle_texture
			
	if damage_time > 0:
		damage_time -= delta
		$Sprite2D.texture = damage_texture
		if damage_time <= 0:
			$Sprite2D.texture = idle_texture
			
	if Input.is_action_just_pressed(mov_dict["cast"]):
		cast_code = ""
		var to_remove = []
		for i in binary_nodes:
			to_remove.append(i)
		
		for i in to_remove:
			i.queue_free()
			
		binary_nodes.clear()
		
	if Input.is_action_pressed(mov_dict["cast"]):
		if Input.is_action_just_pressed(mov_dict["left"]):
			cast_code = cast_code + "0"
			create_binary_node(0)
		if Input.is_action_just_pressed(mov_dict["right"]):
			cast_code = cast_code + "1"
			create_binary_node(1)
		$UI/CastCode.text = cast_code
			
	if cast_code in cast_codes:
		technique = code_to_spell[cast_code]
		cast_time = 2
		cast_code = ""
		if technique == "Black Hole":
			
			emit_signal("blackhole_cast", self)
			var label = Label.new()
			label.text = "CURSED TECHNIQUE: AURA"
			label.position = position + Vector2(0, -64)
			get_parent().add_child(label)
			Globals.labels.append(label)
	
			var hole = blackhole.instantiate()
			hole.position = position
			hole.caster = self
			get_parent().add_child(hole)
			
		if technique == "Ghost Dogs":
			
			var label = Label.new()
			label.text = "CURSED TECHNIQUE: DAWG"
			label.position = position + Vector2(0, -64)
			get_parent().add_child(label)
			Globals.labels.append(label)
			
			var dog = ghostdogsscenespawner.instantiate()
			dog.position = position
			get_parent().add_child(dog)
			dog.connect("spawn_dog", spawn_dog)
			
		if technique == "Energy Shot":
			
			var label = Label.new()
			label.text = "CURSED TECHNIQUE: BALL"
			label.position = position + Vector2(0, -64)
			get_parent().add_child(label)
			Globals.labels.append(label)
			
			var shot = shotscene.instantiate()
			shot.position = position
			shot.set_velocity(enemy.position - position)
			shot.exceptions.append(self)
			get_parent().add_child(shot)
			
		if technique == "Hollow Purple":
			
			emit_signal("blackhole_cast", self)
			var label = Label.new()
			label.text = "CURSED TECHNIQUE: HOLLOW PURPLE"
			label.position = position + Vector2(0, -64)
			get_parent().add_child(label)
			Globals.labels.append(label)
	
			var purple = hollowpurple.instantiate()
			purple.position = position
			purple.caster = self
			get_parent().add_child(purple)
			
		if technique == "Energy Shot Small":
			
			var label = Label.new()
			label.text = "CURSED TECHNIQUE: THOUSAND SHOTS"
			label.position = position + Vector2(0, -64)
			get_parent().add_child(label)
			Globals.labels.append(label)
			
			for i in range(60):	
				var shot = smallshotscene.instantiate()
				shot.position = enemy.position + Vector2(Globals.rng.randi_range(100,1000),0).rotated(Globals.rng.randi_range(0,360))
				shot.set_velocity((enemy.position - shot.position).rotated(Globals.rng.randf_range(-.2,.2)))
				shot.exceptions.append(self)
				get_parent().add_child(shot)
			
	if Input.is_action_just_pressed(mov_dict["up"]):
		apply_central_force(Vector2(0,-1) * jump_force)
	
	
	physics_material_override.friction = .8
	if Input.is_action_pressed(mov_dict["left"]):
		apply_central_force(Vector2(-1,0) * move_force)
		physics_material_override.friction = .1
	if Input.is_action_pressed(mov_dict["right"]):
		apply_central_force(Vector2(1,0) * move_force)
		physics_material_override.friction = .1
		
	flip_x = sign(enemy.position.x - position.x)
	ammo += delta
	ammo = clamp(ammo,0,3)
	if Input.is_action_just_pressed(mov_dict["down"]) and ammo > 1:
		ammo -= 1
		var slash = slash_scene.instantiate()
		slash.position = position
		slash.flip_x = flip_x
		slash.set_velocity()
		slash.exceptions.append(self)
		get_parent().add_child(slash)

func get_energy(num):
	cursed_energy += num
	
func spawn_dog(pos):
	var dog = ghostdogsscene.instantiate()
	dog.position = pos
	dog.target = enemy
	get_parent().add_child(dog)
	
func take_dmg(dmg):
	hp -= dmg
	var label = Label.new()
	label.text = "-" + str(dmg)
	label.position = position + Vector2(Globals.rng.randf_range(0,64), 0).rotated(Globals.rng.randf_range(0, PI * 2))
	get_parent().add_child(label)
	Globals.labels.append(label)
	emit_signal("give_energy", dmg)
	damage_time = .5

func recoil(pos):
	var vec = (position - pos)
	apply_central_force(vec.normalized() * 100000)
	
func create_binary_node(num):
	var new_bin = Sprite2D.new()
	new_bin.texture = symbols[num]
	new_bin.z_index = 2
	add_child(new_bin)
	binary_nodes.append(new_bin)
	
func manage_nodes():
	var n = 0
	for i in binary_nodes:
		n += 1
		var power = 32 + len(binary_nodes) * 1
		i.global_position = global_position + Vector2(power, 0).rotated(n/16.0 * PI * 2 + nodes_phase)
