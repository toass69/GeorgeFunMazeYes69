
extends KinematicBody

var books_collected = 0

var mouseSens = .25
var direction:Vector3
var velocity:Vector3
var movementSpeed=10
var gravity=-0.98
var maxFallSpeed=-30


func _ready():
	if OS.has_feature("JavaScript"):
		var js_code = """
		(function() {
			if (window.godotMouseLockInstalled) return;
			window.godotMouseLockInstalled = true;

			document.addEventListener("click", function() {
				var canvas = document.querySelector("canvas");
				if (canvas && document.pointerLockElement !== canvas) {
					canvas.requestPointerLock();
				}
			});
		})();
		"""
		JavaScript.eval(js_code, true)


func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(deg2rad(-event.relative.x * mouseSens))
			
func _physics_process(delta):
	
	velocity.y = gravity
	if velocity.y<maxFallSpeed:
		velocity.y=maxFallSpeed
	if is_on_floor():
		velocity.y=-5
	
	#movements
	direction.x=Input.get_action_strength("right")-Input.get_action_strength("left")
	direction.z=Input.get_action_strength("backward")-Input.get_action_strength("forward")
	direction=direction.normalized()
	direction=direction.rotated(Vector3.UP,rotation.y)
	velocity.x=direction.x*movementSpeed
	velocity.z=direction.z*movementSpeed
	move_and_slide(velocity,Vector3.UP)
	pass
