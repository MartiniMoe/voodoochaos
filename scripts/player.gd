extends KinematicBody2D

var tilemap

var alive = true
var last_move_time = 0
var time_elapsed = 0
var idle_time = .25

func _ready():
	tilemap = get_parent().get_node("level01")
	set_fixed_process(true)

func _fixed_process(delta):
	if alive:
		move_player()
		check_collisions()
	time_elapsed+=delta
	
	if (time_elapsed - last_move_time > idle_time):
		get_node("AnimationPlayer").set_current_animation("idle")
	else:
		if (get_node("AnimationPlayer").get_current_animation() != "walk"):
			get_node("AnimationPlayer").set_current_animation("walk")
	

func check_collisions():
	var tile_x = floor(get_pos().x / tilemap.get_cell_size().x)
	var tile_y = floor(get_pos().y / tilemap.get_cell_size().y)
	var tile_pos = tilemap.world_to_map(self.get_pos())
	var tile_index = tilemap.get_cell(tile_pos.x, tile_pos.y)
	#print("im on tile #" + str(tile_index) + " " + str(tile_pos.x) + "|" + str(tile_pos.y))
	if tile_index == 0:
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
	self.move(Vector2(move_x, move_y))

func die():
	get_node("Particles2D").set_emitting(true)
	get_node("Sprite").set_opacity(0.5)
	alive = false