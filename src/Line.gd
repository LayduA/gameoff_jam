extends Area2D

@export var line_speed = 2.5
var velocity
# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(line_speed, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += velocity
		
func _on_screen_exited():
	self.position.x = 0.0

