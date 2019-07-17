extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const SPEED = 300
const JUMP = -500

var motion = Vector2()

func _ready():
	pass 

func get_Input():
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var jump = Input.is_action_just_pressed("ui_up")
	
	if is_on_floor() and jump:
		motion.y = JUMP
	if right:
		motion.x = SPEED
		$animation.play("run")
		$Sprite.flip_h = true
	elif left:
		motion.x = -SPEED
		$animation.play("run")
		$Sprite.flip_h = false
	else:
		motion.x = 0
		$animation.play("Idle")

func _physics_process(delta):
	motion.y += GRAVITY
	get_Input()
	motion = move_and_slide(motion, UP)