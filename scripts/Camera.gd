extends Camera2D

var _zoom_min = 4;
var _zoom_max = 4;
var _zoomTween: Tween;

const CAMERA_SPEED:int = 300

var is_dragging = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= delta* CAMERA_SPEED/zoom.x
	if Input.is_action_pressed("ui_down"):
		position.y += delta* CAMERA_SPEED/zoom.x
	if Input.is_action_pressed("ui_right"):
		position.x += delta* CAMERA_SPEED/zoom.x
	if Input.is_action_pressed("ui_left"):
		position.x -= delta* CAMERA_SPEED/zoom.x

func _input(event):
	#Mouse Movements
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_MIDDLE or event.button_index == MOUSE_BUTTON_RIGHT):
		if event.is_released():
			is_dragging = false
		if event.is_pressed():
			is_dragging = true
	if event is InputEventMouseMotion and is_dragging:
		position -=event.relative /zoom.x
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		if zoom.x * 1.1 < _zoom_min:
			zoom *= 1.1
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		if zoom.x / 1.1 > _zoom_max:
			zoom /= 1.1
	


func _on_tree_tree_growing(height):
	var maxedZoom = is_equal_approx(zoom.x,_zoom_max);
	var zoom_scale = 180.0/(height+20);
	_zoom_max = max(0.25, min(_zoom_min, zoom_scale));
	
	#print('Tree Height:', height, ' current_zoom:', zoom.x ,' _zoom_max:', _zoom_max,' zoom scale: ', zoom_scale);

	if (maxedZoom || (_zoomTween && _zoomTween.is_running())):
		if _zoomTween: _zoomTween.stop();
		_zoomTween = create_tween();
		_zoomTween.tween_property(self, "zoom", Vector2(_zoom_max, _zoom_max), 1).set_ease(Tween.EASE_IN_OUT);
