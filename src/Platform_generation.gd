extends Node2D

var platforms

# Called when the node enters the scene tree for the first time.
func _ready():
	print($Platform.get_signal_list())
	platforms = []
	for i in range(10):
		platforms.append(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_note_1"):
		platforms[1] = _start_generating_platform(1)
	if Input.is_action_just_released("ui_note_1"):
		platforms[1].stop_generating()

func _start_generating_platform(index):
	var platform = Platform.new()
	add_child(platform)
	platform.is_generating = true
	platform.set_y_coordinate(50)
	print(platform.get_signal_connection_list(""))
	return platform
