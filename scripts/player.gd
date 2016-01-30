extends KinematicBody2D

var tilemap

var alive = true

func _ready():
	tilemap = get_parent().get_node("level01")
	set_fixed_process(true)

func _fixed_process(delta):
	if alive:
		move_player()
		check_collisions()

func check_collisions():
	var tile_x = floor(get_pos().x / tilemap.get_cell_size().x)
	var tile_y = floor(get_pos().y / tilemap.get_cell_size().y)
	var tile_pos = tilemap.world_to_map(self.get_pos())
	var tile_index = tilemap.get_cell(tile_pos.x, tile_pos.y)
	#print("im on tile #" + str(tile_index) + " " + str(tile_pos.x) + "|" + str(tile_pos.y))
	if tile_index == 1:
		die()

func move_player():
	var move_force = 2
	var move_x = 0
	var move_y = 0
	if Input.is_action_pressed("player_01_down"):
		move_y += move_force
	if Input.is_action_pressed("player_01_top"):
		move_y -= move_force
	if Input.is_action_pressed("player_01_right"):
		move_x += move_force
	if Input.is_action_pressed("player_01_left"):
		move_x -= move_force
	
	self.move(Vector2(move_x, move_y))

func die():
	alive = false