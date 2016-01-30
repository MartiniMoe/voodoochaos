extends KinematicBody2D

var tremble_strength = 2
var stab_scale_time = 0.2
var stab_timeout = 1

var stabbed = false
var stab_timer = 0
var stab_scaled = false

const ARM_LEFT = 0
const ARM_RIGHT = 1
const EYE_LEFT = 2
const EYE_RIGHT = 3
const HEAD = 4
const HEART = 5
const LEG_LEFT = 6
const LEG_RIGHT = 7

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	tremble()
	move_needle()
	stab(delta)

func stab(delta):
	if stabbed && stab_scaled && stab_timer >= stab_scale_time:
		get_node("Sprite").set_scale(Vector2(1, 1))
		stab_scaled = false
	if stabbed && stab_timer < stab_timeout:
		stab_timer += delta
	if stabbed && stab_timer >= stab_timeout:
		stabbed = false
		stab_timer = 0
	if Input.is_action_pressed("voodoo_stab") && !stabbed && stab_timer == 0:
		stabbed = true
		get_node("Sprite").set_scale(Vector2(0.6, 0.6))
		stab_scaled = true
		stab_evaluation()

func stab_evaluation():
	var doll = self.get_parent()
	for body in doll.get_node("arm_left").get_overlapping_bodies():
		if "needle" in body.get_groups():
			stab_action(ARM_LEFT)
			pass
	for body in doll.get_node("arm_right").get_overlapping_bodies():
		if "needle" in body.get_groups():
			stab_action(ARM_RIGHT)
			pass
	for body in doll.get_node("eye_left").get_overlapping_bodies():
		if "needle" in body.get_groups():
			stab_action(EYE_LEFT)
			pass
	for body in doll.get_node("eye_right").get_overlapping_bodies():
		if "needle" in body.get_groups():
			stab_action(EYE_RIGHT)
			pass
	for body in doll.get_node("head").get_overlapping_bodies():
		if "needle" in body.get_groups():
			stab_action(HEAD)
			pass
	for body in doll.get_node("heart").get_overlapping_bodies():
		if "needle" in body.get_groups():
			stab_action(HEART)
			pass
	for body in doll.get_node("leg_left").get_overlapping_bodies():
		if "needle" in body.get_groups():
			stab_action(LEG_LEFT)
			pass
	for body in doll.get_node("leg_right").get_overlapping_bodies():
		if "needle" in body.get_groups():
			stab_action(LEG_RIGHT)
			pass

func stab_action(bodypart):
	pass

func move_needle():
	var move_force = 2
	var move_x = 0
	var move_y = 0
	if Input.is_action_pressed("voodoo_down"):
		move_y += move_force
	if Input.is_action_pressed("voodoo_up"):
		move_y -= move_force
	if Input.is_action_pressed("voodoo_right"):
		move_x += move_force
	if Input.is_action_pressed("voodoo_left"):
		move_x -= move_force
	self.move(Vector2(move_x, move_y))

func tremble():
	#randomize()
	self.set_pos(Vector2(self.get_pos().x + rand_range(-tremble_strength, tremble_strength), self.get_pos().y + rand_range(-tremble_strength, tremble_strength)))