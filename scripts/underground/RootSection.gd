extends Node2D
class_name RootSection

@export var source: Vector2
@export var target: Vector2
@export var growthRate: float = 100;
@export var width = 10;
@export var widthGrowth = 2;


@onready var line = $Line2D
@onready var collisionShape = $Area2D/CollisionShape2D
@onready var collisionArea = $Area2D;

var parent: RootSection = null;
var segment = SegmentShape2D.new();

var _done = false;

func _ready():
	if parent:
		source = parent.get_end_point();
		
	line.default_color = Color(0,0,0)
	line.add_point(source.move_toward(target, -1));
	line.add_point(source);
	segment.a = source;
	segment.b = source;
	collisionShape.shape = segment;
	
	if parent:
		parent.added_child();

func _physics_process(delta):
	if (!_done):
		var start_point = line.get_point_position(1);
		var point = start_point.move_toward(target, growthRate * delta);

		# Don't need to look for intersections if we don't let the user try and make them
		#
		#var space_state = self.get_parent().get_world_2d().direct_space_state
		#
		## use global coordinates, not local to node		
		#var query = PhysicsRayQueryParameters2D.create(line.global_position + start_point, line.global_position + point, 4294967295, [get_collision_RID()] );
		#query.collide_with_areas = true
		#query.hit_from_inside = true
		#var result = space_state.intersect_ray(query)
		#
		#if result:
			#target = point;
			
		if (is_equal_approx(point.x, target.x) && is_equal_approx(point.y, target.y)):
			_done = true;
			point = target;
			
		line.set_point_position(1, point);
		segment.b = point;
		
		#make room for more growth
		if _done:
			var room_to_grow = source.move_toward(target, 1);
			segment.a = room_to_grow;
			
			room_to_grow = target.move_toward(source, 1);
			segment.b = room_to_grow;
			

func nearest_point_to(x:Vector2):
	var p2 = target;
	if (!_done):
		p2  = line.get_point_position(1);
	
	return Geometry2D.get_closest_point_to_segment(x, source, p2);
	
func get_end_point():
	if (_done):
		return line.get_point_position(1);
	else:
		return line.get_point_position(0);

func get_collision_RID():
	return collisionArea.get_rid();

func added_child():
	width += widthGrowth;
	line.width = width;
	if parent:
		parent.added_child();
