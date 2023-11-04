extends CharacterBody2D

@export var line_speed = 300.0

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = line_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide()
		
func _on_screen_exited():
	self.position.x = 0.0

