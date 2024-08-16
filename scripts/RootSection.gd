extends Line2D
class_name RootSection

@export var source: Vector2
@export var target: Vector2
@export var growthRate: float = 100;

var _done = false;
var length = 0;

func _ready():
	default_color = Color(0,0,0)
	add_point(source);
	add_point(source);

func _process(delta):
	if (!_done):
		var point = get_point_position(1).move_toward(target, growthRate * delta);
		
		if (is_equal_approx(point.x, target.x) && is_equal_approx(point.y, target.y)):
			_done = true;
			point = target;
		set_point_position(1, point);
		length = source.distance_to(point);

func nearest_point_to(x:Vector2):
	var p2 = target;
	if (!_done):
		p2  = get_point_position(1);
	
	return Geometry2D.get_closest_point_to_segment(x, source, p2);
	
