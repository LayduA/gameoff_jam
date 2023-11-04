extends Node2D

var platform
var generating
var action

# Called when the node enters the scene tree for the first time.
func _ready():
	generating = -1
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(10):
		action = "ui_note_" + str(i)
		if Input.is_action_just_pressed(action) and generating == -1:
			platform = _start_generating_platform(i)
			generating = i
		if Input.is_action_just_released(action) and generating == i:
			platform.stop_generating()
			generating = -1

func _start_generating_platform(index):
	var plat = Platform.new()
	add_child(plat)
	plat.is_generating = true
	plat.set_y_coordinate((10 - index) * 70)
	return plat
