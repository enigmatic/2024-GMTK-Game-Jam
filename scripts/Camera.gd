extends Camera2D

var _zoom_min = 4;
var _zoom_max = 4;
var _zoomTween: Tween;

const CAMERA_SPEED:int = 300

var is_dragging:bool = false
var first_zoom_complete:bool = false
var moveable_rocks_complete:bool = false
var rats_complete:bool = false
signal tutorial_step

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
		
	if position.x+(320.0/zoom.x) > limit_right:
		position.x = limit_right-(320.0/zoom.x)
	if position.x-(320.0/zoom.x) < limit_left:
		position.x = limit_left+(320.0/zoom.x)
	if position.y+(180.0/zoom.y) > limit_bottom:
		position.y = limit_bottom-(180.0/zoom.y)
	if position.y-(180.0/zoom.y) < limit_top:
		position.y = limit_top+(180.0/zoom.y)

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
	if !moveable_rocks_complete and position.y >= 200:
		tutorial_step.emit(2)
		moveable_rocks_complete = true
	elif !rats_complete and position.y >= 750:
		tutorial_step.emit(3)
		rats_complete = true
		
		


func _on_tree_tree_growing(height):
	var maxedZoom = is_equal_approx(zoom.x,_zoom_max);
	var zoom_scale = 180.0/(height+20);
	_zoom_max = max(0.25, min(_zoom_min, zoom_scale));
	
	if !first_zoom_complete and zoom.x < 4:
		first_zoom_complete = true
		tutorial_step.emit(1)
	
	if (maxedZoom || (_zoomTween && _zoomTween.is_running())):
		if _zoomTween: _zoomTween.stop();
		_zoomTween = create_tween();
		_zoomTween.tween_property(self, "zoom", Vector2(_zoom_max, _zoom_max), 1).set_ease(Tween.EASE_IN_OUT);

func move_camera_to(pos:Vector2, zoom:float):
	_zoomTween = create_tween();
	_zoomTween.tween_property(self, "zoom", Vector2(zoom, zoom), 1).set_ease(Tween.EASE_IN_OUT);
	var move_tween = create_tween();
	move_tween.tween_property(self, "position", pos, 2).set_ease(Tween.EASE_IN_OUT);
