@tool
extends UndergroundVolume
class_name Water
@onready var water_consume_sfx: AudioStreamPlayer2D = $WaterConsumeSFX

@export_range(1,100) var max_volume = 20:
	set(new_max):
		_volume = new_max;
		max_volume = new_max
		@warning_ignore("integer_division")
		variation = min(variation, max_volume/2);
		_randomizeStructure();
	
var _volume = max_volume;
var _original_water_points: SS2D_Point_Array;

func _ready():
	@warning_ignore("integer_division")
	variation = min(variation, max_volume/2);
	_volume = max_volume;
	super._ready();
	_randomizeStructure();

func _updateVolume():
	var points = _orignalPoints.clone(true);
	for i in range(0, points.get_point_count()-1):
		var point = points.get_point_at_index(i);
		
		var point_position = Vector2(0,0).direction_to(point.position) * _volume;
		points.set_point_position(points.get_point_key_at_index(i), point_position);
	
	shape.set_point_array(points);
	_original_water_points = null;
	_orignalPoints = points.clone(true);

func _consumeVolume(flow_to:Vector2):
	var points = shape.get_point_array();
	if !_original_water_points:
		_original_water_points = points.clone(true);
	
	for i in range(0, points.get_point_count()-1):
		var source_point = _original_water_points.get_point_at_index(i);
		var length = source_point.position.distance_to(flow_to);
		var ratio = ((max_volume-_volume) / float(max_volume));
		var point_position = source_point.position.move_toward(flow_to, length * ratio);
		
		points.set_point_position(points.get_point_key_at_index(i), point_position);
	

func consume(units:int, consuming_location:Vector2) -> int:
	var consumed = min(_volume, units)
	_volume -= units;
	water_consume_sfx.pitch_scale = randf_range(.9,1.1)
	water_consume_sfx.play(0.0)
	if _volume > 0:
		_consumeVolume(to_local(consuming_location));

	if _volume <= 0:
		$FreeTimer.start()
	return consumed;
	
func _randomizeStructure():
	if !shape:
		return;
		
	_updateVolume();
	super._randomizeStructure();


func reset(amount:int):
	_volume += amount;
	_updateVolume();


func _on_free_timer_timeout():
	queue_free()
