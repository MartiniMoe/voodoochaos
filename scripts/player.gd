extends KinematicBody2D

var tilemap

var alive = true
var jumping = false
var jump_timer = 0
var jump_cooldown = 0
var jump_duration = 0.6
var last_move_time = 0
var time_elapsed = 0
var idle_time = .25

func _ready():
	tilemap = get_parent().get_node("level01")
	set_fixed_process(true)
	connect("stab", self, "stabbed")

func _fixed_process(delta):
	if !jumping && jump_cooldown > 0:
		jump_cooldown -= delta
	if jumping:
		jump_timer += delta
	if jump_timer >= jump_duration:
		jumping = false
		jump_timer = 0
		get_node("AnimationPlayer").set_current_animation("walk")
		get_node("AnimationPlayer").play("walk")
	if alive:
		move_player()
		check_collisions()
	time_elapsed+=delta
	
	if (time_elapsed - last_move_time > idle_time) && !jumping:
		get_node("AnimationPlayer").set_current_animation("idle")
	elif (get_node("AnimationPlayer").get_current_animation() != "walk") && !jumping:
		get_node("AnimationPlayer").set_current_animation("walk")
	

func check_collisions():
	var tile_x = floor(get_pos().x / tilemap.get_cell_size().x)
	var tile_y = floor(get_pos().y / tilemap.get_cell_size().y)
	var tile_pos = tilemap.world_to_map(self.get_pos())
	var tile_index = tilemap.get_cell(tile_pos.x, tile_pos.y)
	#print("im on tile #" + str(tile_index) + " " + str(tile_pos.x) + "|" + str(tile_pos.y))
	if tile_index == 0 && !jumping:
		get_node("particles_dead").set_emitting(true)
		die()
	for body in get_parent().get_node("main_camera/left_wall").get_overlapping_bodies():
		if body == self:
			get_node("particles_dead_wall").set_emitting(true)
			die()

func move_player():
	var move_force = 2
	var move_x = 0
	var move_y = 0
	if Input.is_action_pressed("player_01_down"):
		move_y += move_force
		set_rot(0)
	if Input.is_action_pressed("player_01_top"):
		move_y -= move_force
		set_rot(PI)
	if Input.is_action_pressed("player_01_right"):
		move_x += move_force
		set_rot(PI/2)
	if Input.is_action_pressed("player_01_left"):
		move_x -= move_force
		set_rot(PI+PI/2)
	if (move_x + move_y) != 0:
		last_move_time = time_elapsed
	if Input.is_action_pressed("player_01_jump") && !jumping && jump_cooldown <= 0:
		jump_cooldown = 0.5
		jumping = true
		get_node("AnimationPlayer").set_current_animation("jump")
		get_node("AnimationPlayer").play("jump")
	self.move(Vector2(move_x, move_y))

func die():
	get_node("Sprite").hide()
	get_node("SpriteDead").show()
	alive = false
	
	
func stabbed(bodypart):
	print("ouch!" + bodypart)