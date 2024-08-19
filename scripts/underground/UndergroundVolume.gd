@tool
extends UndergroundCollidable
class_name UndergroundVolume

@export var randomSeed:int = 0:
	set(new_seed):
		randomSeed = new_seed;
		_randomizeStructure();
		
@export_range(0,30) var variation:int = 20:
	set(new_variation):
		variation = new_variation;
		_randomizeStructure();
		

@onready var shape = $SS2D_Shape
@onready var _orignalPoints: SS2D_Point_Array = shape.get_point_array();

func _ready():
	_randomizeStructure();

func _randomizeStructure():
	if !_orignalPoints:
		return;
		
	if randomSeed && randomSeed != 0:
		seed(randomSeed);
	else:
		return;
	
	var points = _orignalPoints.clone(true);
	for i in range(0, points.get_point_count()-1):
		var point = points.get_point_at_index(i);
		var point_position = point.position.move_toward(Vector2(0,0),randf_range(-variation,variation));
		points.set_point_position(points.get_point_key_at_index(i), point_position);
	shape.set_point_array(points);

func reset(amount:int):
	pass
