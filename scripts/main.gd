
extends Node2D


func _ready():	
	set_fixed_process(true)

func _fixed_process(delta):
	var cam = get_node("main_camera")
	var vp = get_node("Viewport")
	
	var cam_speed=0.5
	var cam_x = cam.get_offset().x+cam_speed
	
	
	cam.make_current()	
	cam.set_offset(Vector2(cam_x, 0))