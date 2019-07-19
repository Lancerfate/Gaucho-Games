extends KinematicBody2D

onready var Player = get_parent().get_node("Player")

#vel = motion
#grav = GRAVITY


const UP = Vector2(0,-1)
const GRAVITY = 500
const SPEED = 300
const JUMP = -300

var motion = Vector2()

var react_time = 400
var dir = 0
var next_dir = 0
var next_dir_time = 0
var target_player_dist = 70

var next_jump_time = -1

var eye_reach = 90
var vision = 400

func _ready():
	pass 

func set_dir(target_dir):
	if next_dir != target_dir:
		next_dir = target_dir
		next_dir_time = OS.get_ticks_msec() + react_time

func sees_player():
	var eye_center = get_global_position()
	var eye_top = eye_center + Vector2(0, -eye_reach)
	var eye_right = eye_center + Vector2(eye_reach, 0)
	var eye_left = eye_center + Vector2(-eye_reach, 0) 
	
	var player_pos = Player.get_global_position()
	var player_extents = Player.get_node("CollisionShape2D").shape.extents - Vector2(1,1)
	var top_left = player_pos + Vector2(-player_extents.x, -player_extents.y)
	var top_right = player_pos + Vector2(player_extents.x, -player_extents.y)
	var bottom_left = player_pos + Vector2(-player_extents.x, player_extents.y)
	var bottom_right = player_pos + Vector2(player_extents.x, player_extents.y)

	var space_state = get_world_2d().direct_space_state
	
	for eye in [eye_center, eye_left, eye_right, eye_top]:
		for corner in [top_left, top_right, bottom_left, bottom_right]:
			if(corner - eye).length() > vision:
				continue
			var collision = space_state.intersect_ray(eye, corner, [], 1)
			if collision and collision.collider.name == "Player":
				return true
	return false


func _physics_process(delta):
	motion.y += GRAVITY * delta
	
	
	if Player.position.x > position.x + target_player_dist and sees_player():
		set_dir(1)
	elif Player.position.x < position.x - target_player_dist and sees_player():
		set_dir(-1)
	else:
		set_dir(0)
	
	if OS.get_ticks_msec() > next_dir_time:
		dir = next_dir
		
	if OS.get_ticks_msec() > next_jump_time and next_jump_time != -1 and is_on_floor():
		if Player.position.y > position.y - 62 and sees_player():
			motion.y = JUMP
		next_jump_time = -1
	
	motion.x = dir * SPEED
	
	if Player.position.y < position.y -62 and next_jump_time == -1 and sees_player():
		next_jump_time = OS.get_ticks_msec() + react_time
	
	
	motion = move_and_slide(motion, UP)