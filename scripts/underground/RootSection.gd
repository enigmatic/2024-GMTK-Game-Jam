extends Node2D
class_name RootSection

signal water_flowing(section: RootSection);
signal water_gathered(amount:int);
signal done_growing();

@export var source: Vector2
@export var target: Vector2
@export var growthRate: float = 100;
@export var width = 2;
@export var widthGrowth = 2;
@export var dropSpeed:float = 50;


@onready var line = $Line2D
@onready var collisionShape = $Area2D/CollisionShape2D
@onready var collisionArea = $Area2D;
@onready var consumeTimer = $ConsumeTimer;
@onready var main_drop = $WaterDrop
@onready var drops = $Drops
@onready var endCap:Sprite2D = $EndCap



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
		
func remove():
	if parent:
		parent.removed_child();
	queue_free();

func _process(delta):
	if (!_doneGrowing):
		var start_point = line.get_point_position(1);
		
		var point = target;
		if parent:
			point = start_point.move_toward(target, growthRate * delta);
			
		if (is_equal_approx(point.x, target.x) && is_equal_approx(point.y, target.y)):
			_doneGrowing = true;
			point = target;
			
		line.set_point_position(1, point);
		segment.b = point;
		endCap.position = point;
		
		#make room for more growth
		if _doneGrowing:
			var room_to_grow = source.move_toward(target, 1);
			segment.a = room_to_grow;
			
			room_to_grow = target.move_toward(source, 1);
			segment.b = room_to_grow;
			
			if touching: 
				consume();
			done_growing.emit();
				
	for drop in drops.get_children():
		var source_global = to_global(source);
		drop.position = drop.position.move_toward(source_global, dropSpeed * delta);
		if (is_equal_approx(drop.position.x, source_global.x) && is_equal_approx(drop.position.y, source_global.y)):
			if parent:
				parent.start_drop();
			else:
				water_gathered.emit(1);
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
		return null;

func get_collision_RID():
	return collisionArea.get_rid();

func added_child():
	width += widthGrowth;
	line.width = width;
	endCap.texture.height = width + widthGrowth;
	endCap.texture.width = width + widthGrowth;
	if parent:
		parent.added_child();
		
func removed_child():
	width -= widthGrowth;
	line.width = width;
	endCap.texture.height = width + widthGrowth;
	endCap.texture.width = width + widthGrowth;
	if parent:
		parent.removed_child();

func  consume():
	if touching && is_instance_valid(touching):
		if touching.type() == 'water':
			if (touching.consume(1, to_global(target)) > 0):
				consumeTimer.start();
				start_drop();
			else:
				touching = null;

func _on_consume_timer_timeout():
	consume()

func start_drop():
	emit_water_flow();
	var newDrop:Sprite2D = main_drop.duplicate();
	newDrop.texture.height = max(3, width);
	newDrop.texture.width = max(3, width);
	newDrop.position = to_global(target);
	newDrop.visible = true;
	drops.add_child(newDrop, true);

func emit_water_flow():
	water_flowing.emit(self);
	if (parent):
		parent.emit_water_flow();
