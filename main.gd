extends Node3D
var peer = ENetMultiplayerPeer.new()

@export var Player_scene:PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _on_host_pressed() -> void:
	add_player(1)
	peer.create_server(1028)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)


func _on_join_pressed() -> void:
	peer.create_client("27.252.78.173",1028)
	multiplayer.multiplayer_peer = peer
	
func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)
	
func add_player(id = 1):
	var player = Player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)

func del_player(id):
	rpc("_del_player", id)
	
@rpc("any_peer","call_local")
func _del_player(id):
	get_node(str(id)).queue_free()
