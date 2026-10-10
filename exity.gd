extends Spatial

var exit_scene = preload("res://exit.tscn")
var exit_spawned = false

func spawn_exit():
	if exit_spawned:
		return

	var exit = exit_scene.instance()
	add_child(exit)

	exit.translation = Vector3(36.845, 1.64, -22.655) # Change spawn position!
	exit_spawned = true
