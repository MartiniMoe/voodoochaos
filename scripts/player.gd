extends KinematicBody2D

var tilemap

export var player_number = 0
var joy_tresh = 0.8

var alive = true
var jumping = false
var jump_timer = 0
var jump_cooldown = 0
var jump_duration = 0.6
var last_move_time = 0
var time_elapsed = 0
var idle_time = .25

var base_speed = 2
var speed = base_speed

var last_punishment_time = 0
var punishment_duration = 1

func _ready():
	tilemap = get_parent().get_node("level01")
	set_fixed_process(true)
	add_to_group("player")
	
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
	
	if (time_elapsed - last_punishment_time > punishment_duration):
		speed = base_speed

func check_collisions():
	var tile_x = floor(get_pos().x / tilemap.get_cell_size().x)
	var tile_y = floor(get_pos().y / tilemap.get_cell_size().y)
	var tile_pos = tilemap.world_to_map(self.get_pos())
	var tile_index = tilemap.get_cell(tile_pos.x, tile_pos.y)
	
	if is_colliding() && "trap" in get_collider().get_groups():
		get_node("particles_dead").set_emitting(true)
		die()
	
	if tile_index == 0 && !jumping:
		get_node("particles_dead").set_emitting(true)
		die()
	for body in get_parent().get_node("main_camera/left_wall").get_overlapping_bodies():
		if body == self:
			get_node("particles_dead_wall").set_emitting(true)
			die()

func move_player():
	var move_force = speed
	var move_x = 0
	var move_y = 0
	if Input.is_action_pressed("player_"+str(player_number)+"_down") || Input.get_joy_axis(player_number, 1) < -joy_tresh:
		move_y += move_force
		set_rot(0)
	if Input.is_action_pressed("player_"+str(player_number)+"_up") || Input.get_joy_axis(player_number, 1) > joy_tresh:
		move_y -= move_force
		set_rot(PI)
	if Input.is_action_pressed("player_"+str(player_number)+"_right") || Input.get_joy_axis(player_number, 0) > joy_tresh:
		move_x += move_force
		set_rot(PI/2)
	if Input.is_action_pressed("player_"+str(player_number)+"_left") || Input.get_joy_axis(player_number, 0) < -joy_tresh:
		move_x -= move_force
		set_rot(PI+PI/2)
	if (move_x + move_y) != 0:
		last_move_time = time_elapsed
	if Input.is_action_pressed("player_"+str(player_number)+"_jump") && !jumping && jump_cooldown <= 0:
		jump_cooldown = 0.5
		jumping = true
		get_node("AnimationPlayer").set_current_animation("jump")
		get_node("AnimationPlayer").play("jump")
	self.move(Vector2(move_x, move_y))

func die():
	get_node("Sprite").hide()
	get_node("SpriteDead").show()
	clear_shapes()
	alive = false
	
	
func punish(punishment):
	if punishment == "pokeleft":
		self.move(Vector2(20,0))
	if punishment == "pokeright":
		self.move(Vector2(-20,0))
	if punishment == "slower":
		speed = speed / 2
	if punishment == "faster":
		speed = speed * 2
	
	last_punishment_time = time_elapsed