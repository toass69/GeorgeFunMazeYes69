extends Spatial

var exit_scene = preload("res://exit.tscn")
var exit_spawned = false

func spawn_exit():
	if exit_spawned:
		return

	var exit = exit_scene.instance()
	add_child(exit)

	exit.translation = Vector3(0, 1, 37) # Change spawn position!
	exit_spawned = true
