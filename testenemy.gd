
extends KinematicBody

export var speed := 5.0

var player: Spatial
var active := false

func _ready():
	player = get_node("/root/Spatial/Player")

	# Enemy starts inactive
	set_physics_process(false)

	# Disable the enemy's physical collision shape
	$CollisionShape.disabled = true

	$AudioStreamPlayer3D.stream_paused = true


	# Disable the separate hit detection area
	$HitArea.monitoring = false


func activate_enemy():
	active = true

	# Enable physical collision
	$CollisionShape.disabled = false

	# Enable player detection
	$HitArea.monitoring = true

	$AudioStreamPlayer3D.stream_paused = false
	# Start the AI
	set_physics_process(true)


func _physics_process(delta):
	if not active:
		return

	if not is_instance_valid(player):
		return

	look_at(player.global_transform.origin, Vector3.UP)

	var velocity = -global_transform.basis.z * speed
	move_and_slide(velocity)


func _on_HitArea_body_entered(body):
	if not active:
		return

	if body == player:
		get_tree().change_scene("res://gameover.tscn")
