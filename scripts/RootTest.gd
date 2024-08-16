extends Node2D

@onready var rootList = $RootList;
@onready var targetNode = $Target;

var _nearestNode: Vector2;

func _input(event):
	if event is InputEventMouseButton and event.is_released() and event.button_index == 1:
		print("Mouse ", event.button_index, " Click at: ", event.position);
		_growRoot(event.position);
	
	if event is InputEventMouseMotion:
		_findNearestRootNode(event.position)
		
		targetNode.position = _nearestNode
		targetNode.look_at(event.position);
		

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
	
