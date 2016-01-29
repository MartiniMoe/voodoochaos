extends KinematicBody2D

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
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
	
	move(Vector2(move_x, move_y))