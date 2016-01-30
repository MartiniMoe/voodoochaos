extends Node2D

var cam
var doll
var cam_speed=0.5

func _ready():
	cam = get_node("main_camera")
	doll = get_node("doll")
	set_fixed_process(true)

func _fixed_process(delta):
	var cam_x = cam.get_pos().x+cam_speed
	
	cam.make_current()
	cam.set_pos(Vector2(cam_x, 0))
	