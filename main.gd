extends Node3D
var peer = ENetMultiplayerPeer.new()
@export var player: PackedScene
const PLAYER = preload("uid://10mssr510n43")
var players = []
@export var Player_scene:PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Networking.host_created.connect(on_host_created)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func on_host_created():
	
	multiplayer.peer_connected.connect(spawn_player)
	
	
	
func spawn_player(peer_id:int):
	var new_player = PLAYER.instantiate()
	new_player.name = str(peer_id)
	add_child(new_player)
	initialize_player(new_player)


func initialize_player(player):
	for other in players:
		player.add_collision_exception_with(other)
	players.append(player)
	
	
func _on_host_pressed() -> void:
	Networking.host_lobby()
	spawn_player(multiplayer.get_unique_id())

func _on_multiplayer_spawner_spawned(node: Node) -> void:
	if node is CharacterBody3D:
		initialize_player(node)
#func _on_join_pressed() -> void:
	#peer.create_client("127.0.0.1",1028)
	#multiplayer.multiplayer_peer = peer
	#
	#
