extends Sprite

var quetschpower = 100
var quetschintervall = 2
var quetschdauer = 2
var quetschtimer = 0
var quetsch = false

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if !quetsch && quetschtimer < quetschintervall:
		quetschtimer += delta
	if !quetsch && quetschtimer >= quetschintervall:
		get_node("lower").apply_impulse(get_node("lower").get_pos(), Vector2(0, -quetschpower))
		get_node("upper").apply_impulse(get_node("upper").get_pos(), Vector2(0, quetschpower))
		quetsch = true
		quetschtimer = 0
	if quetsch && quetschtimer < quetschdauer:
		quetschtimer += delta
	if quetsch && quetschtimer >= quetschdauer:
		get_node("lower").apply_impulse(get_node("lower").get_pos(), Vector2(0, quetschpower))
		get_node("upper").apply_impulse(get_node("upper").get_pos(), Vector2(0, -quetschpower))
		quetsch = false
		quetschtimer = 0