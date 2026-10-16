
extends KinematicBody

export var speed := 5.0
export var repath_time := 0.3
export(NodePath) var navigation_path = NodePath("/root/Spatial/Navigation")

var player: Spatial
var navigation: Navigation
var active := false

var path := PoolVector3Array()
var path_index := 0
var repath_timer := 0.0


func _ready():
	player = get_node("/root/Spatial/Player")
	navigation = get_node(navigation_path)

	# Enemy starts inactive.
	set_physics_process(false)

	$CollisionShape.disabled = true
	$HitArea.monitoring = false
	$AudioStreamPlayer3D.stream_paused = true


func activate_enemy():
	if active:
		return

	active = true

	$CollisionShape.disabled = false
	$HitArea.monitoring = true
	$AudioStreamPlayer3D.stream_paused = false

	path = PoolVector3Array()
	path_index = 0
	repath_timer = 0.0

	set_physics_process(true)


func _physics_process(delta):
	if not active:
		return

	if not is_instance_valid(player):
		return

	# Recalculate the route periodically as the player moves.
	repath_timer -= delta

	if repath_timer <= 0.0:
		repath_timer = repath_time
		path = navigation.get_simple_path(
			global_transform.origin,
			player.global_transform.origin,
			true
		)
		path_index = 0

	if path.size() == 0:
		return

	# Skip path points that the enemy has already reached.
	while path_index < path.size():
		var distance = global_transform.origin.distance_to(
			path[path_index]
		)

		if distance > 0.35:
			break

		path_index += 1

	if path_index >= path.size():
		return

	# Move toward the next point along the calculated route.
	var target = path[path_index]
	var direction = target - global_transform.origin

	if direction.length() > 0.0:
		direction = direction.normalized()

		# Rotate horizontally toward the next waypoint.
		var flat_direction = Vector3(
			direction.x, 0.0, direction.z
		)

		if flat_direction.length() > 0.01:
			look_at(
				global_transform.origin + flat_direction,
				Vector3.UP
			)

		move_and_slide(direction * speed)


func _on_HitArea_body_entered(body):
	if not active:
		return

	if body == player:
		get_tree().change_scene("res://gameover.tscn")
