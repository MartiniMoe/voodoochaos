extends Node2D

var cam
var doll
var spawn
var cam_speed=0.5

var voodoo_joystick = 0

var spawn_time = 5
var time_elapsed = 0

func _ready():
	cam = get_node("main_camera")
	set_fixed_process(true)

func _fixed_process(delta):
	if time_elapsed > spawn_time:
		var cam_x = cam.get_pos().x+cam_speed
		cam.make_current()
		cam.set_pos(Vector2(cam_x, 0))
	time_elapsed += delta
	
	var all_win = true
	var all_dead = true
	for body in get_children():
		if "player" in body.get_groups():
			if body.alive:
				all_dead = false
			if !body.won:
				all_win = false

func stab(punishment):
	for i in range (get_child_count()):
		if "player" in get_child(i).get_groups():
			get_child(i).punish(punishment)