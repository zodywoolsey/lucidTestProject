extends Spatial

var up 		= false
var down 	= false
var left 	= false
var right 	= false

var damp = 0.1
var speed = 4
var maxspeed = 30

onready var body = get_node("KinematicBody")
onready var tween = get_node("Tween")

var velocity = Vector3(0,0,0)

signal move(velocity_vector)


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	body.linear_damp = damp
	# velocity = body.linear_velocity

	if up == true && velocity.z > -maxspeed:
		velocity += Vector3.FORWARD*speed
	if right == true && velocity.x < maxspeed:
		velocity += Vector3.RIGHT*speed
	if left == true && velocity.x > -maxspeed :
		velocity += Vector3.LEFT*speed
	if down == true && velocity.z < maxspeed :
		velocity += Vector3.BACK*speed
	# if up == false && down == false:
	# 	velocity.z = velocity.z/damp
	# 	body.linear_velocity.z = body.linear_velocity.z/damp
	# if left == false && right == false:
	# 	velocity.x = velocity.x/damp
	# 	body.linear_velocity.x = body.linear_velocity.x/damp
	# if !(body.linear_velocity.x < maxspeed && body.linear_velocity.x > -maxspeed && body.linear_velocity.z < maxspeed && body.linear_velocity.z > -maxspeed):
	# 	velocity = velocity/damp
	# 	body.linear_velocity = body.linear_velocity/damp
	
	# velocity.z = velocity.z*damp
	# body.linear_velocity.z = body.linear_velocity.z*damp
	# velocity.x = velocity.x*damp
	# body.linear_velocity.x = body.linear_velocity.x*damp
	velocity -= velocity*damp

	# print(velocity)
	# body.add_central_force(velocity)
	body.linear_velocity = velocity
	emit_signal("move",velocity)
	# if (left == true || right == true || up == true || down == true) && (body.linear_velocity.x < maxspeed && body.linear_velocity.x > -maxspeed && body.linear_velocity.z < maxspeed && body.linear_velocity.z > -maxspeed):
	# 	body.linear_velocity = velocity
	# 	emit_signal("move",body.linear_velocity)
	

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_up"):
		up = true
	if event.is_action_pressed("ui_right"):
		right = true
	if event.is_action_pressed("ui_left"):
		left = true
	if event.is_action_pressed("ui_down"):
		down = true
	# if event.is_action_pressed("jump"):
	# 	body.apply_central_impulse(Vector3.UP*10)

	if event.is_action_released("ui_up"):
		up = false
	if event.is_action_released("ui_right"):
		right = false
	if event.is_action_released("ui_left"):
		left = false
	if event.is_action_released("ui_down"):
		down = false

func tween_move_to(pos):
	tween.interpolate_property(body,"transform:origin",body.transform.origin,pos,0.05,Tween.TRANS_LINEAR)
