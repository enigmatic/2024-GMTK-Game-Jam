extends Node2D

@export var groundLevel: int = 0;
@export var rootSectionMaxSize = 100;
@export var rootSectionMinSize = 25;

@onready var rootList = $RootList;
@onready var targetNode = $Target;
@onready var ghostLine = $GhostLine
var _nearestNode: Vector2;
var _planning_to_draw = false;

func _input(event):
	
	if event is InputEventMouse:
		var targetClamp = get_local_mouse_position();
		targetClamp.y = max(groundLevel, targetClamp.y);
		
		var end_point = _nearestNode.move_toward(targetClamp, rootSectionMaxSize);
		
		_updateBasedOnTarget(end_point);
		
		if event is InputEventMouseButton and event.button_index == 1:
			if event.is_released():
				var okToGrow = true;
				if (_nearestNode.distance_to(end_point) < rootSectionMinSize):
					okToGrow = false;
				else: 
					var collidedWith = checkCollision(_nearestNode, end_point);
					if collidedWith:
						okToGrow = check_valid_target_node(collidedWith);
					
				if okToGrow:
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
	# line location
	ghostLine.set_point_position(0, _nearestNode);
	ghostLine.set_point_position(1, target);
	
	# will it run into anything?
	var collidedWith = checkCollision(_nearestNode, target);
	
	if collidedWith:
		ghostLine.default_color = Color(1,0,0);
	elif (_nearestNode.distance_to(target) < rootSectionMinSize):
		ghostLine.default_color = Color(1,1,1);
	else:
		ghostLine.default_color = Color(0,1,0);

func _updateBasedOnTarget(target: Vector2):
	var targetPos = target
	_findNearestRootNode(targetPos)
	
	targetNode.position = _nearestNode
	targetNode.look_at(targetPos);
	
	if _planning_to_draw:
		_draw_ghost_line(targetPos);

func checkCollision(_nearestNode, target):
	var space_state = get_world_2d().direct_space_state
		
	var query = PhysicsRayQueryParameters2D.create(self.global_position + _nearestNode, self.global_position + target);
	query.collide_with_areas = true
	query.hit_from_inside = true
	var hit = space_state.intersect_ray(query);
	if hit:
		var collider = hit.collider;
		if collider.has_method("is_blocker"):
			return collider
		
	return null;

func check_valid_target_node(node:UndergroundCollidable):
	return !node.is_blocker();
