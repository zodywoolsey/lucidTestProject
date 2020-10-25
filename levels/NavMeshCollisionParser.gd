extends Spatial


onready var rigidmapmeshes = get_tree().get_nodes_in_group("RigidMapMesh")


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in rigidmapmeshes:
		# if i.name[0] == 'w' && i.name[1] == 'a' && i.name[2] == 'l':
		# 	i.mesh.size.y = 20
		# 	i.transform.origin.y = 10
		var tmpbody = RigidBody.new()
		var tmpcollisionshape = CollisionShape.new()
		# i.mesh.subdivide_depth = i.mesh.size.z*1
		# i.mesh.subdivide_height = i.mesh.size.y*1
		# i.mesh.subdivide_width = i.mesh.size.x*1
		var tmpshape = i.mesh.create_trimesh_shape()
		tmpshape.margin = 0.0
		tmpcollisionshape.shape = tmpshape
		tmpbody.add_child(tmpcollisionshape)

		tmpbody.mode = RigidBody.MODE_STATIC
		tmpbody.contact_monitor = true
		tmpbody.can_sleep = false
		tmpbody.continuous_cd = false
		tmpbody.mass = 65535
		tmpbody.weight = 65535
		tmpbody.set_collision_layer_bit(1,true)
		tmpbody.set_collision_mask_bit(1,true)

		tmpbody.add_child(AudioStreamPlayer3D.new())
		i.add_child(tmpbody)
		# tmpbody.connect("body_entered",self,"collisionsound")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# func collisionsound(col):
# 	print("collided with: " + col.name)
