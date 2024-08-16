extends Node2D

@export var groundLevel: int = 0;

@onready var rootList = $RootList;
@onready var targetNode = $Target;
@onready var ghostLine = $GhostLine
var _nearestNode: Vector2;
var _planning_to_draw = false;

func _input(event):
	
	if event is InputEventMouse:
		var targetPos = event.position;
		targetPos.y = max(groundLevel, targetPos.y);
		_updateBasedOnTarget(targetPos);
		
		if event is InputEventMouseButton and event.button_index == 1:
			if event.is_released():
				_growRoot(targetPos);
				ghostLine.visible = false;
				_planning_to_draw = false;
			else:
				ghostLine.visible = true;
				_planning_to_draw = true;
				_draw_ghost_line(targetPos);

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
	targetPos.y = max(groundLevel,targetPos.y);
	_findNearestRootNode(targetPos)
	
	targetNode.position = _nearestNode
	targetNode.look_at(targetPos);
	
	if _planning_to_draw:
		_draw_ghost_line(targetPos);
