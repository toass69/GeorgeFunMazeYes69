
extends KinematicBody

export var speed := 5.0
export var repath_time := 2.0
export var wander_radius := 15.0
export var gravity := 20.0
export(NodePath) var navigation_path = NodePath("/root/Spatial/Navigation")

var navigation: Navigation
var path := PoolVector3Array()
var path_index := 0
var repath_timer := 0.0
var wander_origin := Vector3.ZERO
var vertical_velocity := 0.0


func _ready():
	randomize()

	navigation = get_node(navigation_path)
	wander_origin = global_transform.origin

	# Start wandering immediately.
	$CollisionShape.disabled = false
	$HitArea.monitoring = false


	set_physics_process(true)

	choose_new_destination()


func _physics_process(delta):
	# Gravity.
	if is_on_floor():
		vertical_velocity = 0.0
	else:
		vertical_velocity -= gravity * delta

	# Choose a new destination when needed.
	repath_timer -= delta

	if repath_timer <= 0.0:
		repath_timer = repath_time

		if path.size() == 0 or path_index >= path.size():
			choose_new_destination()

	var horizontal_velocity := Vector3.ZERO

	# Follow the navigation path.
	if path.size() > 0 and path_index < path.size():
		var target = path[path_index]
		var direction = target - global_transform.origin
		direction.y = 0.0

		if direction.length() < 0.5:
			path_index += 1
		else:
			direction = direction.normalized()
			horizontal_velocity = direction * speed

			# Face the walking direction.
			look_at(
				global_transform.origin + direction,
				Vector3.UP
			)

	move_and_slide(
		Vector3(
			horizontal_velocity.x,
			vertical_velocity,
			horizontal_velocity.z
		),
		Vector3.UP
	)

	# Choose another destination after reaching the end.
	if path.size() > 0 and path_index >= path.size():
		path = PoolVector3Array()
		path_index = 0
		repath_timer = 0.5


func choose_new_destination():
	for i in range(10):
		var offset = Vector3(
			rand_range(-wander_radius, wander_radius),
			0.0,
			rand_range(-wander_radius, wander_radius)
		)

		var destination = wander_origin + offset

		var new_path = navigation.get_simple_path(
			global_transform.origin,
			destination,
			true
		)

		if new_path.size() > 1:
			path = new_path
			path_index = 1
			return

	# Retry if no valid destination was found.
	path = PoolVector3Array()
	path_index = 0
	repath_timer = 1.0
