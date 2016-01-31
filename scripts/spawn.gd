extends Sprite

var spawn_time = 5
var time_elapsed = 0

const player_preload = preload("../scenes/player.scn")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if time_elapsed < spawn_time:
		for i in range(128):
			if Input.is_joy_button_pressed(i, 0):
				var exists = false
				for child in get_node("/root/Main").get_children():
					if "player" in child.get_groups():
						if child.player_number == i:
							exists = true
				if !exists:
					var new_player = player_preload.instance()
					new_player.player_number = i
					new_player.set_pos(self.get_pos())
					get_node("/root/Main").add_child(new_player)