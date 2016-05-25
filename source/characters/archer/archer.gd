
extends KinematicBody2D

const MOTION_SPEED = 250

onready var g = get_node("/root/global")
onready var anim = get_node("sprite/anim")

var action = Action.new()
var release_time = {}
var forced_direction

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var motion = Vector2()
	
	var direction
	if Input.is_action_pressed("move_north"):
		direction = g.MOVE_NORTH
	if Input.is_action_pressed("move_south"):
		direction = g.MOVE_SOUTH
	if Input.is_action_pressed("move_west"):
		direction = g.MOVE_WEST
	if Input.is_action_pressed("move_east"):
		direction = g.MOVE_EAST
	if Input.is_action_pressed("move_northeast"):
		direction = g.MOVE_NORTHEAST
	if Input.is_action_pressed("move_northwest"):
		direction = g.MOVE_NORTHWEST
	if Input.is_action_pressed("move_southeast"):
		direction = g.MOVE_SOUTHEAST
	if Input.is_action_pressed("move_southwest"):
		direction = g.MOVE_SOUTHWEST
	
	if direction == g.MOVE_NORTH:
		motion += Vector2(0, -1)
	elif direction == g.MOVE_SOUTH:
		motion += Vector2(0, 1)
	elif direction == g.MOVE_WEST:
		motion += Vector2(-2, 0)
	elif direction == g.MOVE_EAST:
		motion += Vector2(2, 0)
	elif direction == g.MOVE_NORTHEAST:
		motion += Vector2(2, -1)
	elif direction == g.MOVE_NORTHWEST:
		motion += Vector2(-2, -1)
	elif direction == g.MOVE_SOUTHEAST:
		motion += Vector2(2, 1)
	elif direction == g.MOVE_SOUTHWEST:
		motion += Vector2(-2, 1)
	
	if motion.x == 0 and motion.y == 0 or direction == null:
		idle(action.get_direction())
	else:
		run(direction)
	
	motion = motion.normalized() * MOTION_SPEED * delta
	motion = move(motion)
	
	# Make character slide nicely through the world
	var slide_attempts = 4
	while is_colliding() and slide_attempts > 0:
		motion = get_collision_normal().slide(motion)
		motion = move(motion)
		slide_attempts -= 1

func set_current_action(name, direction):
	action.set_name(name)
	action.set_direction(direction)

func play_animation(action, direction):
	stop()
	var name = str(action, "_", direction)
	anim.play(name)

func process_action(verb, direction):
	if action.get_name() != verb or action.get_direction() != direction:
		play_animation(verb, direction)
		set_current_action(verb, direction)

func run(direction):
	process_action("run", direction)

func idle(direction):
	process_action("idle", direction)

func stop():
	if anim.is_playing():
		anim.stop(false)


class Action extends Reference:
	
	var name
	var direction
	
	func set_name(what):
		name = what
	
	func get_name():
		return name
	
	func set_direction(what):
		direction = what
	
	func get_direction():
		return direction