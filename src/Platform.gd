class_name Platform
extends StaticBody2D
 
@onready var is_generating = false
@onready var is_degenerating = false 
var line
var index

func _ready():
	line = get_parent().get_node("line/line_area")
	
	# Fixes the left side of the rectangles to the current position of the line
	var Platform_view = Polygon2D.new()
	Platform_view.set_polygon(PackedVector2Array([
		Vector2(line.position.x, 0),
		Vector2(line.position.x, 10),
		Vector2(line.position.x, 0),
		Vector2(line.position.x, 10),
	]))
	var Platform_hitbox = CollisionPolygon2D.new()
	Platform_hitbox.set_polygon(PackedVector2Array([
		Vector2(line.position.x, 0),
		Vector2(line.position.x, 10),
		Vector2(line.position.x, 0),
		Vector2(line.position.x, 10),
	]))
	Platform_hitbox.set_name("Platform_hitbox")
	self.set_collision_layer_value(4, true)
	self.set_collision_layer_value(5, true)
	Platform_view.set_name("Platform_view")
	self.add_child(Platform_hitbox)
	self.add_child(Platform_view)
	line.get_node("line_screennotifier").connect("screen_exited", stop_generating)
	self.set_visible(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_generating:
		# Pushes the right side of the rectangles to the right with the line
		$Platform_view.polygon[2][0] = line.position.x
		$Platform_view.polygon[3][0] = line.position.x
		$Platform_hitbox.polygon[2][0] = line.position.x
		$Platform_hitbox.polygon[3][0] = line.position.x
		get_parent().use_fuel(0.15)
	if is_degenerating:
		$Platform_view.polygon[0][0] = line.position.x
		$Platform_view.polygon[1][0] = line.position.x
		$Platform_hitbox.polygon[0][0] = line.position.x
		$Platform_hitbox.polygon[1][0] = line.position.x
		if $Platform_view.polygon[0][0] >= $Platform_view.polygon[2][0]:
			queue_free()
		get_parent().refuel(0.15)
	if Input.is_action_just_released("ui_delete_notes"):
		is_degenerating = false

func set_y_coordinate(y):
	$Platform_view.polygon[0][1] = y
	$Platform_view.polygon[1][1] = y + 10
	$Platform_view.polygon[2][1] = y + 10
	$Platform_view.polygon[3][1] = y
	$Platform_hitbox.polygon[0][1] = y
	$Platform_hitbox.polygon[1][1] = y + 10
	$Platform_hitbox.polygon[2][1] = y + 10
	$Platform_hitbox.polygon[3][1] = y

func stop_generating():
	self.is_generating = false
