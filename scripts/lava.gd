
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	for body in self.get_overlapping_bodies():
		print("body in lava")