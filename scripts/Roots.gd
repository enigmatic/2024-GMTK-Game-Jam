extends Node2D

@export var groundLevel: int = 0;
@export var rootSectionMaxSize = 100;

@onready var rootList = $RootList;
@onready var targetNode = $Target;
@onready var ghostLine = $GhostLine
var _nearestNode: Vector2;
var _planning_to_draw = false;

func _input(event):
	
	if event is InputEventMouse:
		var targetClamp = event.position;
		targetClamp.y = max(groundLevel, targetClamp.y);
		
		var end_point = _nearestNode.move_toward(targetClamp, rootSectionMaxSize);
		
		_updateBasedOnTarget(end_point);
		
		if event is InputEventMouseButton and event.button_index == 1:
			if event.is_released():
				_growRoot(end_point);
				ghostLine.visible = false;
				_planning_to_draw = false;
			else:
				ghostLine.visible = true;
				_planning_to_draw = true;
				_draw_ghost_line(end_point);

func _growRoot(target: Vector2):
	var scene = load("res://scenes/RootSection.tscn");
	var section = scene.instantiate();
	section.source = _nearestNode;	
	section.target = target;
	rootList.add_child(section);
	
func _findNearestRootNode(pos: Vector2):
	var roots = rootList.get_children();
	var nearest: Vector2 = roots[0].get_end_point();
	var nearDist = nearest.distance_to(pos);
	for root in roots:
		var testPos = root.get_end_point();
		var dist = testPos.distance_to(pos);
		if (dist < nearDist):
			nearest = testPos;
			nearDist = dist;
			
	_nearestNode = nearest;
	
func _draw_ghost_line(target: Vector2):
	ghostLine.set_point_position(0, _nearestNode);
	ghostLine.set_point_position(1, target);

func _updateBasedOnTarget(target: Vector2):
	var targetPos = target
	_findNearestRootNode(targetPos)
	
	targetNode.position = _nearestNode
	targetNode.look_at(targetPos);
	
	if _planning_to_draw:
		_draw_ghost_line(targetPos);
