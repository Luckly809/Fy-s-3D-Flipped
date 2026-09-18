extends Area3D
var floor : CSGBox3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func body_entered(body):
	floor = body
func area_entered(body):
	floor = body
