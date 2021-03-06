
extends KinematicBody2D

onready var g = get_node("/root/global")
onready var anim = get_node("sprite/anim")
onready var damage_area = get_node("damage_area")
onready var action = g.Action.new()

func _ready():
	add_collision_exception_with(self)
	set_fixed_process(true)

func _fixed_process(delta):
	var direction = g.get_direction()
	var motion = g.get_motion(direction)
	
	if motion.x == 0 and motion.y == 0 or direction == null:
		idle(action.get_direction())
	else:
		run(direction)
	
	motion = motion.normalized() * g.MOTION_SPEED * delta
	motion = move(motion)
	
	# Make character slide nicely through the world
	var slide_attempts = 4
	while is_colliding() and slide_attempts > 0:
		motion = get_collision_normal().slide(motion)
		motion = move(motion)
		slide_attempts -= 1

func take_damage():
	print("archer took damage.")

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
