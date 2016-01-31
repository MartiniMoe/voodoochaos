
extends Sprite

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	for body in get_node("goal").get_overlapping_bodies():
		if "player" in body.get_groups():
			body.win()
	


