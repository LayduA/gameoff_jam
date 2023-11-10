extends Node2D

var platform
var generating
var action
@export var platform_fuel: float
var max_platform_fuel

const frequencies = [
	1.0, 1.122462, 1.259921, 1.33484, 1.498307, 1.681793, 1.88749, 2.0, 2.0, 2.0
]
var audio_players = []
var audio_file = "res://sounds/voice_0.ogg"
var sfx = load(audio_file)

# Called when the node enters the scene tree for the first time.
func _ready():
	generating = -1
	for i in range(10):
		var audio_stream_player = AudioStreamPlayer2D.new()
		audio_players.append(audio_stream_player)
		sfx.set_loop(false)
		audio_players[i].stream = sfx
		audio_players[i].max_polyphony = 8
		audio_players[i].pitch_scale = frequencies[i]
		add_child(audio_stream_player)
	$line/line_area.connect("body_entered", _platform_hit)
	$line/line_area.connect("body_exited", _platform_left)
	_set_max_platform_fuel(100.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for i in range(10):
		action = "ui_note_" + str(i)
		if Input.is_action_just_pressed(action):
			# If a platform is currently generating, stop it.
			if generating != -1:
				platform.stop_generating()
				audio_players[generating].stop()
				
			# Start generating the new platform
			platform = _start_generating_platform(i)
			generating = i
			audio_players[i].play()
			
			# TODO: decrease "voice-meter" of character
		if (Input.is_action_just_released(action) or platform_fuel <= 0) and generating == i:
			platform.stop_generating()
			generating = -1
			# TODO: stop decreasing voice-meter
			audio_players[i].stop()	

func _start_generating_platform(index:int) -> Platform:
	var plat = Platform.new()
	add_child(plat)
	plat.index = index
	plat.is_generating = true
	# TODO: remove magic numbers
	plat.set_y_coordinate((10 - index) * 90)
	return plat

func _platform_hit(platform_object:Object) -> void:
	if Input.is_action_pressed("ui_delete_notes"):
		platform_object.is_degenerating = true
	elif not audio_players[platform_object.index].playing:
		audio_players[platform_object.index].play()

func _platform_left(platform_object:Object) -> void:
	if audio_players[platform_object.index].playing:
		audio_players[platform_object.index].stop()
		
func _set_max_platform_fuel(amount:float) -> void:
	self.max_platform_fuel = amount
	self.platform_fuel = amount
	
func refuel(refuel_amount: float) -> void:
	self.platform_fuel += refuel_amount
	
func use_fuel(fuel_amount: float) -> void:
	self.platform_fuel -= fuel_amount
