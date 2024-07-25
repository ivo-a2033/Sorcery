extends RigidBody2D


var jump_force = 25000
var move_force = 500
var hp = 300
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
var handscene = load("res://hand.tscn")
var dragonshotscene = load("res://dragon_shot.tscn")
var rockscene = load("res://rock_wall.tscn")
var healeffectscene = load("res://heal_effect.tscn")


var enemy 
signal give_energy

var idle_texture = load("res://guy.png")
var cast_texture = load("res://guy_arms_up.png")
var cast_time = 0

var damage_texture = load("res://guy_flipped.png")
var damage_time = 0

signal blackhole_cast

var all_scenes = [blackhole, ghostdogsscene, ghostdogsscenespawner, shotscene, hollowpurple,
					smallshotscene, handscene, dragonshotscene, rockscene, healeffectscene]

var cast_code = ""
var code_to_spell = {
	("0011 0101").replace(" ", ""): "Black Hole",
	("1101 0101 10").replace(" ", ""): "Ghost Dogs",
	("1011 10").replace(" ", ""): "Energy Shot",
	("0101 1010 1111 0011").replace(" ", ""): "Hollow Purple",
	("1010 0100 0010 0000").replace(" ", ""): "Energy Shot Small",
	("0101 0110").replace(" ", ""): "Hand",
	("1110 1101 1011").replace(" ", ""): "Dragon Shot",
	("1010 0111").replace(" ", ""): "Shield",
	("1111 0011 1101").replace(" ", ""): "Rock",
	("1010 0000 0101").replace(" ", ""): "Heal",
}
var cast_codes = code_to_spell.keys()

var binary_nodes = []
var nodes_phase = 0

var symbols = {
	0: load("res://zero_symbol.png"),
	1: load("res://one_symbol.png")
}

var label_settings = load("res://new_label_settings.tres")
var shield_amount = 0

var ui_hp_pos = Vector2(0,0) - Vector2(800,450) #windowsize / 2

var runes = []

var power_level = 1

func stop_stutter():
	for i in all_scenes:
		var a = i.instantiate()
		a.queue_free()
		
		
func _ready():
	if Globals.p1 == null:
		Globals.p1 = self
		runes = Globals.runes1
		
	else:
		Globals.p2 = self
		runes = Globals.runes2
		
		enemy = Globals.p1
		
		enemy.connect("give_energy", get_energy)
		connect("give_energy", enemy.get_energy)
		
		Globals.p1.enemy = self
		
		mov_dict = {
			"up": "up",
			"left": "left",
			"down": "down",
			"right": "right",
			"cast": "l"
		}
		
		ui_hp_pos = Vector2(1300,0) - Vector2(800,450) #windowsize / 2
		
	if "swift" in runes:
		for key in code_to_spell.keys():
			code_to_spell[key.left(len(key)-1)] = code_to_spell[key]
		cast_codes = code_to_spell.keys()
	if "power" in runes:
		power_level = 1.25
		
	print(runes)
	stop_stutter()
		

func _process(delta):
	
	if "bloodlust" in runes:
		power_level = 1
		if "power" in runes:
			power_level = 1.25
		power_level *= 1 + (1 - hp/300.0)
	
	nodes_phase += delta * 5
	manage_nodes()
	
	$UI/HP.value = hp/300.0 * 260 + 40
	$Shield.modulate = Color8(255,255,255, shield_amount)
	
	#hp bar stabilization
	$UI/HP.global_position = Globals.cam.global_position + ui_hp_pos / Globals.cam.zoom_
	$UI/HP.scale = 1.0/Globals.cam.zoom_ * Vector2(1,1) * 4
	
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
		clear_nodes()
		
	if Input.is_action_pressed(mov_dict["cast"]):
		if Input.is_action_just_pressed(mov_dict["left"]):
			cast_code = cast_code + "0"
			create_binary_node(0)
		if Input.is_action_just_pressed(mov_dict["right"]):
			cast_code = cast_code + "1"
			create_binary_node(1)
		$UI/CastCode.text = cast_code
	else:
		physics_material_override.friction = .8
		if Input.is_action_pressed(mov_dict["left"]):
			apply_central_force(Vector2(-1,0) * move_force)
			physics_material_override.friction = .1
		if Input.is_action_pressed(mov_dict["right"]):
			apply_central_force(Vector2(1,0) * move_force)
			physics_material_override.friction = .1
			
	if cast_code in cast_codes:
		technique = code_to_spell[cast_code]
		cast_time = 2
		cast_code = ""
		clear_nodes()
		
		if "luck" in runes and Globals.rng.randi_range(0,4) == 0:
			power_level *= 2
		
		if technique == "Black Hole":
			dialogue("AURA")
	
			var hole = blackhole.instantiate()
			hole.position = position
			hole.caster = self
			get_parent().add_child(hole)
			
		if technique == "Ghost Dogs":
			dialogue("DAWG")
			
			var dog = ghostdogsscenespawner.instantiate()
			dog.position = position
			get_parent().add_child(dog)
			dog.connect("spawn_dog", spawn_dog)
			
		if technique == "Energy Shot":
			dialogue("SHOT")
			
			var shot = shotscene.instantiate()
			shot.position = position
			shot.power_level = power_level
			shot.set_velocity(enemy.position - position)
			shot.exceptions.append(self)
			get_parent().add_child(shot)
				
			print(power_level)
		if technique == "Hollow Purple":
			emit_signal("blackhole_cast", self)
			dialogue("HOLLOW PURPLE")
	
			var purple = hollowpurple.instantiate()
			purple.position = position
			purple.caster = self
			get_parent().add_child(purple)
			
		if technique == "Energy Shot Small":
			dialogue("INFINITE SHOTS")
			
			for i in range(60):	
				var shot = smallshotscene.instantiate()
				shot.power_level = power_level
				shot.position = enemy.position + Vector2(Globals.rng.randi_range(100,1000),0).rotated(Globals.rng.randi_range(0,360))
				shot.set_velocity((enemy.position - shot.position).rotated(Globals.rng.randf_range(-.2,.2)))
				shot.exceptions.append(self)
				get_parent().add_child(shot)
			
		if technique == "Hand":
			dialogue("HAND")
			
			var hand = handscene.instantiate()
			hand.position = enemy.position + Vector2(0,128)
			get_parent().add_child(hand)
		
		if technique == "Dragon Shot":
			dialogue("DRAGON")
			
			for i in range(8):
				var shot = dragonshotscene.instantiate()
				shot.position = position + Vector2(i * 64, Globals.rng.randi_range(256,2048))
				shot.set_velocity(Vector2(0,-1))
				shot.exceptions.append(self)
				get_parent().add_child(shot)
			
			for i in range(8):
				var shot = dragonshotscene.instantiate()
				shot.position = position + Vector2(-i * 64, Globals.rng.randi_range(256,2048))
				shot.set_velocity(Vector2(0,-1))
				shot.exceptions.append(self)
				get_parent().add_child(shot)
				
		if technique == "Shield":
			dialogue("SHIELD")
			shield_amount += 85 * power_level
			
			if shield_amount > 170:
				shield_amount = 170
			
		if technique == "Rock":
			dialogue("ROCK")
			
			var rock = rockscene.instantiate()
			rock.position = position
			get_parent().add_child(rock)
			
		if technique == "Heal":
			dialogue("HEAL")
			
			var healeffect = healeffectscene.instantiate()
			healeffect.power_level = power_level
			add_child(healeffect)
			
		if "luck" in runes:
			power_level = 1
			if "power" in runes:
				power_level = 1.25
			
	if Input.is_action_just_pressed(mov_dict["up"]):
		apply_central_force(Vector2(0,-1) * jump_force)
	
	
	
		
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
	
	
	if hp < 0:
		hp = -9999
		if enemy.hp > 0:
			$UI/HP.rotation = 90


func dialogue(text):
	var label = Label.new()
	label.text = "CURSED TECHNIQUE: " + text
	label.position = position + Vector2(0, -64)
	get_parent().add_child(label)
	Globals.labels.append(label)	
	
	
func get_energy(num):
	cursed_energy += num
	if "heal" in runes:
		heal(num * .25)
	
func spawn_dog(pos):
	var dog = ghostdogsscene.instantiate()
	dog.position = pos
	dog.power_level = power_level
	dog.target = enemy
	get_parent().add_child(dog)
	
func heal(amount):
	hp += amount
	hp = min(300, hp)
	
func take_dmg(dmg):
	
	if "thorns" in runes:
		enemy.take_dmg(dmg * 0.12)
		
	if "invincibility" in runes and Globals.rng.randi_range(0,99) < 15:
		dmg *= 0
		
	if "protection" in runes:
		dmg *= .75
		
	if shield_amount > dmg:
		shield_amount -= dmg
	else:
		dmg -= shield_amount
		shield_amount = 0
		hp -= dmg
		var label = Label.new()
		label.label_settings = label_settings
		label.text = "-" + str(int(dmg))
		label.position = position + Vector2(Globals.rng.randf_range(0,64), 0).rotated(Globals.rng.randf_range(0, PI * 2))
		get_parent().add_child(label)
		Globals.labels.append(label)
		emit_signal("give_energy", dmg)
		damage_time = .5
	cast_code = ""
	clear_nodes()

func recoil(pos):
	var vec = (position - pos)
	apply_central_force(vec.normalized() * 100000)
	
func go(pos, duration):
	var vec = -(position - pos)
	apply_central_force(vec * 1/60.0 * 1/duration * 1000)
	
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
		var power = 32 + 4 * n
		i.global_position = global_position + Vector2(power, 0).rotated(n/16.0 * PI * 2 + nodes_phase * sin(n+2))
		
func clear_nodes():
	var to_remove = []
	for i in binary_nodes:
		to_remove.append(i)
	
	for i in to_remove:
		i.queue_free()
		
	binary_nodes.clear()
