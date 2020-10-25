extends Node

var connected = false
var hosting = false
var thisid
var hostip = "10.0.150.72"
var clients = []

var hostlabel
var connecttext

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("connected_to_server",self,"_connected_to_server")
	get_tree().connect("server_disconnected",self,"_disconnected_from_server")
	hostlabel = get_node("gui/hostip")
	connecttext = get_node("gui/inip")
	# get_node("gui/connect").connect("pressed",self,"_connect")
	# get_node("gui/host").connect("pressed",self,"_host")
	# get_node("gui/force_sync_players").connect("pressed",self,"_force_sync_players")
	# get_node("Spatial/player").connect("move",self,"local_player_moved")

func _process(delta):
	# if connected == true:
		# rpc("_check_player_offset",get_node("Spatial/player").get_node("KinematicBody").transform.origin, thisid)
		# rpc("_move_player",get_node("Spatial/player").get_node("KinematicBody").linear_velocity,get_node("Spatial/player").get_node("KinematicBody").transform.origin, thisid)
	if hosting == true:
		# print(thisid)
		for i in clients:
			rpc_id(int(i.name),"_move_player",get_node("Spatial/player").get_node("KinematicBody").linear_velocity,get_node("Spatial/player").get_node("KinematicBody").transform.origin, thisid)
			_force_sync_players()
			rpc_id(int(i.name),"_check_player_offset",get_tree().get_root().get_node("Node/Spatial").get_node(str(i.name)).get_node("KinematicBody").transform.origin,int(i.name))

func local_player_moved(velocity):
	rpc("_move_player",velocity,get_node("Spatial/player").get_node("KinematicBody").transform.origin, thisid)

func _connect():
	var client = NetworkedMultiplayerENet.new()
	client.create_client(connecttext.text, 5000)
	# client.create_client(hostip, 5000)
	get_tree().network_peer = client
	thisid = get_tree().get_network_unique_id()

func _host():
	var server = NetworkedMultiplayerENet.new()
	# server.set_bind_ip(hostip)
	server.create_server(5000, 5)
	get_tree().network_peer = server
	get_tree().connect("network_peer_connected", self, "_client_connected")
	get_tree().connect("network_peer_disconnected", self, "_client_disconnected")
	for i in IP.get_local_interfaces():
		hostlabel.text += i.name+":\n"
		for a in i.addresses:
			hostlabel.text += "	"+a+"\n"
	thisid = get_tree().get_network_unique_id()

func _client_connected(id):
	var newclient = load("res://netplayer.tscn").instance()
	newclient.set_name(str(id))
	get_tree().get_root().get_node("Node/Spatial").add_child(newclient)
	# print("added client")
	clients.append(newclient)
	hosting = true
	if len(clients) > 1:
		for i in clients:
			for a in clients:
				rpc_id(int(i.name),"_spawn_netplayer",int(a.name))
	rpc_id(id,"_spawn_netplayer",1)

func _client_disconnected(id):
	get_tree().get_root().get_node("Node/Spatial").get_node(str(id)).queue_free()
	if len(get_tree().get_network_connected_peers()) == 0:
		hosting = false


func _connected_to_server():
	connected = true
	thisid = get_tree().get_network_unique_id()

func _disconnected_from_server():
	connected = false

remote func _move_player(velocity,pos,id):
	if connected:
		var startorig = get_tree().get_root().get_node("Node/Spatial").get_node(str(id)).get_node("KinematicBody").transform.origin
		get_tree().get_root().get_node("Node/Spatial").get_node(str(id)).get_node("KinematicBody").linear_velocity = velocity
		# if abs( startorig.distance_to(pos) ) > .01 :
		# 	get_tree().get_root().get_node("Node/Spatial").get_node(str(id)).get_node("KinematicBody").transform.origin = pos

	# get_tree().get_root().get_node("Node/Spatial").get_node(str(id)).get_node("KinematicBody").transform.origin = pos

remote func _check_player_offset(pos, id):
	var startorig = get_tree().get_root().get_node("Node/Spatial").get_node(str(id)).get_node("KinematicBody").transform.origin
	if abs( startorig.distance_to(pos) ) > .05 :
		get_tree().get_root().get_node("Node/Spatial").get_node(str(id)).get_node("KinematicBody").transform.origin = pos

remote func _sync_client_positions(pos,id):
	if id != 0:
		# get_tree().get_root().get_node("Node/Spatial").get_node(str(id)).get_node("KinematicBody").transform.origin = pos
		get_tree().get_root().get_node("Node/Spatial").get_node(str(id)).tween_move_to(pos)
	else:
		# get_tree().get_root().get_node("Node/Spatial/player").get_node("KinematicBody").transform.origin = pos
		get_tree().get_root().get_node("Node/Spatial/player").tween_move_to(pos)

func _force_sync_players():
	if hosting:
		rpc_id(int(clients[0].name),"_sync_client_positions",get_node("Spatial/player").get_node("KinematicBody").transform.origin,1)
		rpc_id(int(clients[0].name),"_sync_client_positions",clients[0].get_node("KinematicBody").transform.origin,0)
		if len(clients) > 1:
			for i in clients:
				for a in clients:
					rpc_id(int(i.name),"_sync_client_positions",a.get_node("KinematicBody").transform.origin,int(a.name))

remote func _spawn_netplayer(id):
	var newclient = load("res://netplayer.tscn").instance()
	newclient.set_name(str(id))
	get_tree().get_root().get_node("Node/Spatial").add_child(newclient)
	clients.append(newclient)
