extends KinematicBody2D

onready var Player = get_parent().get_node("Player")

var vel = Vector2(0,0)

var grav = 1800
var max_grav = 3000

var react_time = 400
var dir = 0
var next_dir = 0
var next_dir_time = 0
var target_player_dist = 60

func _ready():
	set_process(true)
	
func set_dir(target_dir):
	if next_dir != target_dir:
		next_dir = target_dir
		next_dir_time = OS.get_ticks_msec() + react_time
	
func _process(delta):
	
	if Player.position.x > position.x + 60:
		set_dir(1)
	elif Player.position.x < position.x - 60:
		set_dir(-1)
	else:
		set_dir(0)
		
	if OS.get_ticks_msec() > next_dir_time:
		dir = next_dir
		
	vel.x = dir * 500
	
	vel.y += grav * delta
	
	if vel.y > max_grav:
		vel.y = max_grav 
		
	if is_on_floor() and vel.y > 0:
		vel.y = 0
		
	vel = move_and_slide(vel,Vector2(0,-1))