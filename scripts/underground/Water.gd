@tool
extends UndergroundVolume
class_name Water

@export var max_volume = 20:
	set(new_max):
		_volume = new_max;
		max_volume = new_max
		_updateVolume();
	
var _volume;
var _original_points: SS2D_Point_Array;

func _ready():
	variation = max(variation, max_volume/2);
	_volume = max_volume;
	super._ready();
	_updateVolume();
	
func is_blocker():
	return false;
	
func type():
	return 'water';

func _updateVolume():
	var points = shape.get_point_array();
	for i in range(0, points.get_point_count()-1):
		var point = points.get_point_at_index(i);
		
		var point_position = Vector2(0,0).direction_to(point.position) * _volume;
		points.set_point_position(points.get_point_key_at_index(i), point_position);
	
	_original_points = null;

func _consumeVolume(flow_to:Vector2):
	var points = shape.get_point_array();
	if !_original_points:
		_original_points = points.clone(true);
	
	for i in range(0, points.get_point_count()-1):
		var source_point = _original_points.get_point_at_index(i);
		var length = source_point.position.distance_to(flow_to);
		var ratio = ((max_volume-_volume) / float(max_volume));
		var point_position = source_point.position.move_toward(flow_to, length * ratio);
		
		points.set_point_position(points.get_point_key_at_index(i), point_position);
	

func consume(units:int, consuming_location:Vector2) -> int:
	var consumed = min(_volume, units)
	_volume -= units;
	if _volume > 0:
		_consumeVolume(to_local(consuming_location));

	if _volume <= 0:
		queue_free();
		
	return consumed;
	
