extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("{hour}:{second}".format(OS.get_datetime()))
	yield(wait(5), "completed")
	get_tree().quit() # default behavior
	print("{hour}:{second}".format(OS.get_datetime()))

func wait(seconds):
	yield(get_tree().create_timer(seconds), "timeout")

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
