extends Node2D
class_name RootSection

@export var source: Vector2
@export var target: Vector2
@export var growthRate: float = 100;
@export var width = 10;
@export var widthGrowth = 2;
@export var dropSpeed:float = 10;


@onready var line = $Line2D
@onready var collisionShape = $Area2D/CollisionShape2D
@onready var collisionArea = $Area2D;
@onready var consumeTimer = $ConsumeTimer;
@onready var main_drop = $WaterDrop
@onready var drops = $Drops

var parent: RootSection = null;
var touching: UndergroundCollidable = null;
var segment = SegmentShape2D.new();
var _doneGrowing = false;

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

func _process(delta):
	if (!_doneGrowing):
		var start_point = line.get_point_position(1);
		var point = start_point.move_toward(target, growthRate * delta);

		if (is_equal_approx(point.x, target.x) && is_equal_approx(point.y, target.y)):
			_doneGrowing = true;
			point = target;
			
		line.set_point_position(1, point);
		segment.b = point;
		
		#make room for more growth
		if _doneGrowing:
			var room_to_grow = source.move_toward(target, 1);
			segment.a = room_to_grow;
			
			room_to_grow = target.move_toward(source, 1);
			segment.b = room_to_grow;
			
			if touching: 
				consumeTimer.start();
	for drop in drops.get_children():
		var source_global = to_global(source);
		drop.position = drop.position.move_toward(source_global, dropSpeed * delta);
		if (is_equal_approx(drop.position.x, source_global.x) && is_equal_approx(drop.position.y, source_global.y)):
			#TODO: move into parent
			if parent:
				parent.start_drop();
			else:
				pass # TODO: tree get's water?
			drop.queue_free();
			
			

func nearest_point_to(x:Vector2):
	var p2 = target;
	if (!_doneGrowing):
		p2  = line.get_point_position(1);
	
	return Geometry2D.get_closest_point_to_segment(x, source, p2);
	
func get_end_point():
	if (_doneGrowing and !touching):
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


func _on_consume_timer_timeout():
	if touching:
		if touching.type() == 'water':
			if (touching.consume(1, to_global(target))):
				consumeTimer.start();
				start_drop();
			else:
				touching = null;

func start_drop():
	var newDrop:Sprite2D = main_drop.duplicate();
	newDrop.position = to_global(target);
	newDrop.visible = true;
	drops.add_child(newDrop, true);
