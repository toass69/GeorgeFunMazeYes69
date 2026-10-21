extends KinematicBody

export var speed := 7.0
export var detection_range := 10.0
export var teleport_interval := 54.0
export var teleport_distance := 10.0

export(NodePath) var player_path = NodePath("/root/Spatial/Player")

onready var sprite = $AnimatedSprite3D

var player: Spatial
var active := false
var chasing := false
var teleport_timer := 0.0
var current_animation := ""

var rng := RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	player = get_node(player_path)
	set_physics_process(false)
	$CollisionShape.disabled = true

	play_animation("default")


func play_animation(anim_name):
	if current_animation == anim_name:
		return

	current_animation = anim_name
	sprite.play(anim_name)


func activate_enemy():
	if active:
		return

	active = true
	$CollisionShape.disabled = false
	teleport_timer = teleport_interval

	set_physics_process(true)
	teleport_enemy()
	play_animation("default")

func teleport_enemy():
	var offset = Vector3(
		rng.randf_range(-teleport_distance, teleport_distance),
		0.0,
		rng.randf_range(-teleport_distance, teleport_distance)
	)

	global_transform.origin = player.global_transform.origin + offset


func _physics_process(delta):
	if not active or not is_instance_valid(player):
		return

	var distance = global_transform.origin.distance_to(
		player.global_transform.origin
	)

	if distance <= detection_range:
		# If he just noticed the player, start the audio ONCE instead of resetting it
		if not chasing:
			chasing = true
			if not $AudioStreamPlayer3D.playing:
				$AudioStreamPlayer3D.play()
			$AudioStreamPlayer3D.stream_paused = false

	if chasing:
		play_animation("AAAA")
		
		# TWEAKING EFFECT: The closer he gets, the higher and crazier the pitch scale gets!
		# At max detection distance, pitch is 1.0. At 0 distance, pitch rises up to 3.0.
		var proximity_ratio = 1.0 - clamp(distance / detection_range, 0.0, 1.0)
		$AudioStreamPlayer3D.pitch_scale = 1.0 + (proximity_ratio * 2.0) 
		
		var target = player.global_transform.origin
		target.y = global_transform.origin.y

		look_at(target, Vector3.UP)

		var direction = target - global_transform.origin

		if direction.length() > 0.1:
			move_and_slide(direction.normalized() * speed)

		# Teleport both when he catches the player.
		if distance < 1.2:
			teleport_player_and_enemy()

	else:
		play_animation("default")
		# Pause the sound instead of stopping it entirely so it preserves position
		$AudioStreamPlayer3D.stream_paused = true
		teleport_timer -= delta

		if teleport_timer <= 0.0:
			teleport_timer = teleport_interval
			teleport_enemy()


func teleport_player_and_enemy():
	play_animation("AAAA")
	
	# Reset the pitch before blasting it on teleport catch
	$AudioStreamPlayer3D.pitch_scale = 1.0
	$AudioStreamPlayer3D.play()
	
	# TELEPORT FIX: Send the player directly to the specific room coordinate instead of a random spot
	player.global_transform.origin = Vector3(37.0, 1.25, 0.0)

	# Trevor still teleports to his random destination away from the new position
	teleport_enemy()

	chasing = false
	teleport_timer = teleport_interval

func deactivate_enemy():
	active = false
	chasing = false

	$CollisionShape.disabled = true
	$AudioStreamPlayer3D.stop() # Shut him up completely when deactivated
	set_physics_process(false)
	play_animation("default")



