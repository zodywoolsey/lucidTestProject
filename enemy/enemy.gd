extends KinematicBody

export(PoolVector3Array) var route
var routeindex = 0

var path = []
var pathindex = 0
var move_speed = 2
onready var nav = get_tree().root.find_node("Navigation",true,false)
onready var vision = get_node('vision')
onready var visionray = get_node('vision/RayCast')
var playervisible = false
# var visionray

var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('units')
	# move_to(Vector3(0,0,0))
	# visionray = RayCast.new()
	# visionray.enabled = true
	# get_tree().root.get_node('Node/Spatial').add_child(visionray)

func _physics_process(delta):
	var visioncol = vision.get_overlapping_bodies()
	var tmpplayervisible = false
	if len(visioncol) > 0:
		for body in visioncol:
			if body.is_in_group('player'):
				tmpplayervisible = true
				visionray.cast_to = visionray.to_local(body.global_transform.origin)
				if visionray.is_colliding():
					if visionray.get_collider().is_in_group('player'):
						tmpplayervisible = true
						move_to(visionray.get_collider().global_transform.origin)
						var tmpmovepos = (visionray.get_collider().global_transform.origin-global_transform.origin).normalized()
						move_and_slide(tmpmovepos * move_speed, Vector3.UP)
						tmpmovepos = path[pathindex]
						tmpmovepos.y = global_transform.origin.y
						look_at( path[pathindex] , Vector3.UP)
					else:
						tmpplayervisible = false
	playervisible = tmpplayervisible
	if !playervisible:
		print('player not seen')
		if pathindex < path.size():
			var move_vec = (path[pathindex] - global_transform.origin)
			if move_vec.length() < .1:
				pathindex += 1
			else:
				move_and_slide((move_vec.normalized() * move_speed), Vector3.UP)
				var tmplookpos = path[pathindex]
				tmplookpos.y = global_transform.origin.y
				# look_at(tmplookpos, Vector3.UP)
				# print(move_vec.normalized()*move_speed)
		else:
			if len(route) > 1:
				if route.size() > routeindex:
					move_to(route[routeindex])
					routeindex += 1
				else:
					routeindex = 0
			else:
				move_to(Vector3((randi()%28)-26,(randi()%4),(randi()%28)-26))
	if health < 1:
		queue_free()
		
		
func move_to(targetpos):
	path = nav.get_simple_path(global_transform.origin, targetpos)
	pathindex = 0

	
# func _on_vision_body_entered(body):
# 	var visionray = RayCast.new()
# 	get_tree().root.add_child(visionray)
# 	visionray.global_transform.origin = global_transform.origin
# 	if body.is_in_group('player'):
# 		visionray.cast_to = body.global_transform.origin
# 		print(body.global_transform.origin)
# 		if visionray.is_colliding():
# 			# if visionray.get_collider():
# 			print(visionray.get_collider())
