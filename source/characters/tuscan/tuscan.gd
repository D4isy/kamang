
extends KinematicBody2D

const MOTION_SPEED = 150

onready var anim = get_node("sprite/anim")
onready var g = get_node("/root/global")

var Action = preload("res://source/common/action.gd")

var action = Action.new()
var ai = AI.new()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if action.get_name() != null:
		if action.get_name() == "walk":
			ai.on_walk(delta, self)
		elif action.get_name().begins_with("attack"):
			if is_colliding():
				print("true")
			ai.on_attack(delta, self)

func play_animation(action, direction):
	stop()
	var name = str(action, "_", direction)
	anim.play(name)

func stop():
	if anim.is_playing():
		anim.stop(false)

func set_current_action(name, direction):
	action.set_name(name)
	action.set_direction(direction)

func process_action(verb, direction):
	if action.get_name() != verb or action.get_direction() != direction:
		play_animation(verb, direction)
		set_current_action(verb, direction)

func walk(direction):
	process_action("walk", direction)

func attack(type, direction):
	process_action(str("attack", type), direction)

func activate_ai():
	var direction = g.get_random_direction()
	walk(direction)


class AI extends Reference:
	
	func on_attack(delta, tuscan):
		pass
	
	func on_walk(delta, tuscan):
		var direction = tuscan.action.get_direction()
		var motion = tuscan.g.get_motion(direction)
		
		motion = motion.normalized() * MOTION_SPEED * delta
		motion = tuscan.move(motion)
		
		if tuscan.is_colliding():
			if tuscan.get_collider().get_name() == "archer":
				tuscan.attack(1, direction)
			else:
				direction = tuscan.g.get_opposite_direction(direction)
				tuscan.walk(direction)
