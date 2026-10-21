extends Area

func _on_StaticBody_body_entered(body):
	if body.name == "Player":

		# Make the book disappear
		get_node("/root/Spatial/George").visible = false

		# Disable the book's collision
		$CollisionShape.disabled = true

		# Show the enemy
		get_node("/root/Spatial/GeorgeRedd").visible = true

		# Update book counter
		body.books_collected += 1
		get_node("/root/Spatial/ProgressBar").text = str(body.books_collected) + "/7 Books"
		queue_free()

	if body.books_collected == 1:
		var enemy = get_node_or_null("/root/Spatial/GeorgeRedd")
		if enemy:
			enemy.activate_enemy()
		# Remove the books
		var music = get_node_or_null("/root/Spatial/AudioStreamPlayer")
		if music:
			music.queue_free()
		# Remove the books
		

	if body.books_collected == 4:
		get_node("/root/Spatial/Trevor").activate_enemy()

	if body.books_collected == 7:
		var world_env = get_node("/root/Spatial/WorldEnvironment")
		var exit = get_node_or_null("/root/Spatial")
		var wall = get_node_or_null("/root/Spatial/FakeWall")
		if wall:
			wall.queue_free()
		if exit != null:
			exit.spawn_exit()

		if world_env != null and world_env.environment != null:
			var env = world_env.environment
			env.ambient_light_color = Color(1, 0, 0)
			env.ambient_light_energy = 1.0
			env.ambient_light_sky_contribution = 0.0

		print("RED AMBIENT LIGHT ACTIVATED!")
	else:
		print("ERROR: WorldEnvironment has no Environment resource!")
