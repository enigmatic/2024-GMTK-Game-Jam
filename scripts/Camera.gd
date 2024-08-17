extends Camera2D

var is_dragging = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		if event.is_released():
			is_dragging = false
		if event.is_pressed():
			is_dragging = true
	if event is InputEventMouseMotion and is_dragging:
		position -=event.relative /zoom.x
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		zoom *= 1.1
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		zoom /= 1.1
