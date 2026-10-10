
extends KinematicBody

var books_collected = 0

var mouseSens = .25
var direction:Vector3
var velocity:Vector3
var movementSpeed=10


func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass


func _input(event):
	if event is InputEventMouseMotion:
		
		rotate_y(deg2rad(-event.relative.x*mouseSens))
		pass
	pass

func _physics_process(delta):
	#movements
	direction.x=Input.get_action_strength("right")-Input.get_action_strength("left")
	direction.z=Input.get_action_strength("backward")-Input.get_action_strength("forward")
	direction=direction.normalized()
	direction=direction.rotated(Vector3.UP,rotation.y)
	velocity.x=direction.x*movementSpeed
	velocity.z=direction.z*movementSpeed
	move_and_slide(velocity,Vector3.UP)
	pass
