extends UndergroundCollidable
class_name UndergroundVolume

@export var randomSeed = 0;
@export var variation = 20;

@onready var shape = $SS2D_Shape

func _ready():
	var points = shape.get_point_array().clone(true);
	shape.set_point_array(points);
	self.randomize();

func randomize():
	if (randomSeed != 0):
		seed(randomSeed);
	
	var points = shape.get_point_array();
	for i in range(0, points.get_point_count()-1):
		var point = points.get_point_at_index(i);
		var point_position = point.position.move_toward(Vector2(0,0),randf_range(-variation,variation));
		points.set_point_position(points.get_point_key_at_index(i), point_position);
	#shape.set_point_array(points);
