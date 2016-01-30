extends Node2D

var cam
var vp
var doll
var cam_speed=0.5

func _ready():
	cam = get_node("main_camera")
	vp = get_node("Viewport")
	doll = get_node("doll")
	set_fixed_process(true)

func _fixed_process(delta):
	var cam_x = cam.get_offset().x+cam_speed
	
	cam.make_current()
	cam.set_offset(Vector2(cam_x, 0))
	doll.set_pos(Vector2(cam.get_offset().x - (get_viewport().get_rect().end.x/2) + doll.get_texture().get_width(), doll.get_pos().y))