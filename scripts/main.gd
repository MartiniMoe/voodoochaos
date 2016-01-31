extends Node2D

var cam
var doll
var cam_speed=0.5

func _ready():
	cam = get_node("main_camera")
	set_fixed_process(true)
	
func _fixed_process(delta):
	var cam_x = cam.get_pos().x+cam_speed
	
	cam.make_current()
	cam.set_pos(Vector2(cam_x, 0))
	
func stab():
	for i in range (get_child_count()):
    	get_child(i).stab(0)
