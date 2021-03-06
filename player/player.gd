extends KinematicBody

var gravity = -9.8
var velocity = Vector3()
var animplayer
var character
const MAX_SPEED = 10
const ACCELERATION = 3
const DE_ACCELERATION = 15
const DEADZONE = 0.2
const JUMP_SPEED = 7
func _ready():
	character = get_node(".")

	

func _physics_process(delta):
	var dir = Vector3(0,0,0)
	var ismoving = false
	if Input.is_action_pressed("ui_up"):
		dir -=  Vector3(0,0,1)
		ismoving = true
	if Input.is_action_pressed("ui_down"):
		dir +=  Vector3(0,0,1)
		ismoving = true
	if Input.is_action_pressed("ui_left"):
		dir -=  Vector3(1,0,0)
		ismoving = true
	if Input.is_action_pressed("ui_right"):
		dir +=  Vector3(1,0,0)
		ismoving = true
	dir.y = 0
	dir = dir.normalized()

	velocity.y += delta * gravity

	var hv = velocity
	hv.y = 0

	if velocity.y > 0:
		gravity = -20
	else:
		gravity = -30 

	var new_pos = dir * MAX_SPEED
	var accel = DE_ACCELERATION

	if dir.dot(hv) > 0:
		accel = ACCELERATION

	hv = hv.linear_interpolate(new_pos, accel * delta)

	velocity.x = hv.x
	velocity.z = hv.z
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	_Globals.player_locale = transform.origin
	
	#set rotation
	if ismoving == true:

		var angle = atan2(hv.x, hv.z)
		var char_rot = character.get_rotation()

		char_rot.y = angle
		character.set_rotation(char_rot)

	if (is_on_floor() and Input.is_action_pressed("ui_accept")):
		velocity.y = JUMP_SPEED

