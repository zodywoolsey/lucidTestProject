extends Spatial

var up 		= false
var down 	= false
var left 	= false
var right 	= false

var damp = 1.1
var speed = 1
var maxspeed = 20

onready var body = get_node("KinematicBody")

var velocity = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	body.linear_velocity.z = body.linear_velocity.z/damp
	body.linear_velocity.x = body.linear_velocity.x/damp


	# print(velocity)
	# body.add_central_force(velocity)
	# body.linear_velocity = velocity
