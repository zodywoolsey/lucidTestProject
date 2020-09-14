extends Spatial

var up 		= false
var down 	= false
var left 	= false
var right 	= false

var damp = 0.8
var speed = 1
var maxspeed = 20

onready var body = get_node("KinematicBody")

var velocity = Vector3(0,0,0)

func _ready():
	pass

func _process(delta):
	body.linear_damp = damp

	# velocity.z = velocity.z*damp
	# body.linear_velocity.z = body.linear_velocity.z*damp
	# velocity.x = velocity.x*damp
	# body.linear_velocity.x = body.linear_velocity.x*damp

