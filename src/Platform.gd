class_name Platform
extends StaticBody2D
 
@onready var is_generating = false # Boolean to toggle (mainly to stop) a platform generation
var line


func _ready():
	line = get_parent().get_node("Line").get_node("Line_body")
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
	Platform_view.set_name("Platform_view")
	self.add_child(Platform_hitbox)
	self.add_child(Platform_view)
	line.get_node("Line_notifier").connect("screen_exited", stop_generating)
	self.set_visible(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_generating:
		# Pushes the right side of the rectangles to the right with the line
		$Platform_view.polygon[2][0] = line.position.x
		$Platform_view.polygon[3][0] = line.position.x
		$Platform_hitbox.polygon[2][0] = line.position.x
		$Platform_hitbox.polygon[3][0] = line.position.x

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
