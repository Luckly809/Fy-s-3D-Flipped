extends CharacterBody3D
@onready var neck: Node3D = $Neck/Camera3D
@onready var camera_3d: Camera3D = $Neck/Camera3D
@onready var area_3d: Area3D = $Area3D
@onready var Multiplayer: Node3D = $"../Node3D"
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D



var SPEED = 2.0
const JUMP_VELOCITY = 4.5
const ACCELERATION = 50.0  
const MOUSE_SENS:float = 0.005
@export var Grav = Vector3(0,1,0)
@export var max_speed = 10.0
@export var friction = 4
var Max = 1
var Min = -1
var flipped = false
var Rev = 1

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	neck.current = is_multiplayer_authority()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_motion:Vector2 = event.relative
		rotate_y(-(mouse_motion.x * MOUSE_SENS * Rev))
		neck.rotate_x(-(mouse_motion.y * MOUSE_SENS))
		neck.rotation.x = clamp(neck.rotation.x, -1.5, 1.5)
	
	
func _physics_process(delta: float) -> void:
	Grav = up_direction
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * Grav
		
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity += JUMP_VELOCITY * Grav
		
	if Input.is_action_just_pressed("Flip ") and is_on_floor():
		flip()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * max_speed, ACCELERATION * delta * 10)
		velocity.z = move_toward(velocity.z, direction.z * max_speed, ACCELERATION * delta * 10)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta * 10)
		velocity.z = move_toward(velocity.z, 0, friction * delta * 10)
	move_and_slide()
	
	if position.y < -10:
		position = Vector3(0, 1, 0)
		
	if position.y > 10:
		flip()
		velocity = Vector3(0, 1, 0)
		position = Vector3(0, 1, 0)

func flip():
	if is_on_floor():
		position -= up_direction
	rotation_degrees += Vector3(0,0,180)
	neck.rotation.z *= -.5
	up_direction *= -1
	Max *= -1
	Min *= -1
	Rev *= -1
	


func _on_exit_pressed() -> void:
	$"../".exit_game(name.to_int())
	get_tree().quit
