extends Generic6DOFJoint


onready var startorigin = global_transform.origin
onready var neworigin = Vector3()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
	
	
func _physics_process(delta):
	neworigin = global_transform.origin
	set("linear_limit_x/lower_distance",(neworigin.x-startorigin.x))
	set("linear_limit_x/upper_distance",(neworigin.x-startorigin.x)+.001)
	set("linear_limit_y/lower_distance",(neworigin.y-startorigin.y))
	set("linear_limit_y/upper_distance",(neworigin.y-startorigin.y)+.001)
	set("linear_limit_z/lower_distance",(neworigin.z-startorigin.z))
	set("linear_limit_z/upper_distance",(neworigin.z-startorigin.z)+.001)
