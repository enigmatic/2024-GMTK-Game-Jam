extends Node2D
class_name Root

signal growing_root;
signal water_gathered(amount:int);

@export var groundLevel: int = 0;
@export var rootSectionMaxSize = 100;
@export var rootSectionMinSize = 25;

@onready var rootList = $RootList;
@onready var targetNode = $Target;
@onready var ghostLine = $GhostLine;
@onready var _nearestNode: RootSection = $RootList/RootSection;

var canGrow = true;

var _planning_to_draw = false;

func _input(event):
	
	if event is InputEventMouse:
		if canGrow:
			var targetClamp = get_local_mouse_position();
			targetClamp.y = max(groundLevel, targetClamp.y);
			var start_point = _nearestNode.get_end_point();
			var end_point = start_point.move_toward(targetClamp, rootSectionMaxSize);
			
			_updateBasedOnTarget(end_point);
			
			if event is InputEventMouseButton and event.button_index == 1:
				if event.is_released():
					var okToGrow = true;
					var collideWith = null;
					if (start_point.distance_to(end_point) < rootSectionMinSize):
						okToGrow = false;
					else: 
						var hitInfo = checkCollision(start_point, end_point);
						if hitInfo:
							collideWith = hitInfo.collider;
							okToGrow = check_valid_target_node(collideWith);
							end_point = to_local(hitInfo.position);
						
					if okToGrow:
						_growRoot(end_point, collideWith);
						
					ghostLine.visible = false;
					_planning_to_draw = false;
				else:
					ghostLine.visible = true;
					_planning_to_draw = true;
					_draw_ghost_line(start_point, end_point);

func _growRoot(target: Vector2, collidedWith: UndergroundCollidable = null):
	
	var scene = load("res://scenes/RootSection.tscn");
	var section = scene.instantiate();
	section.parent = _nearestNode;
	section.target = target;
	section.touching = collidedWith;
	rootList.add_child(section);
	growing_root.emit();
	
func _findNearestRootNode(pos: Vector2):
	var roots = rootList.get_children();
	var nearest: RootSection = roots[0]
	var nearDist = nearest.get_end_point().distance_to(pos);
	for root in roots:
		var testPos = root.get_end_point();
		var dist = testPos.distance_to(pos);
		if (dist < nearDist):
			nearest = root;
			nearDist = dist;
			
	_nearestNode = nearest;
	
func _draw_ghost_line(start: Vector2, target: Vector2):
	# line location
	ghostLine.set_point_position(0, start);
	ghostLine.set_point_position(1, target);
	
	# will it run into anything?
	var hitInfo = checkCollision(start, target);
	
	if hitInfo:
		var collidedWith = hitInfo.collider;
		if (collidedWith.type() == 'water'):
			ghostLine.default_color = Color(0,0,1);
			ghostLine.set_point_position(1, to_local(hitInfo.position));
		else:
			ghostLine.default_color = Color(1,0,0);
	elif (start.distance_to(target) < rootSectionMinSize):
		ghostLine.default_color = Color(1,1,1);
	else:
		ghostLine.default_color = Color(0,1,0);

func _updateBasedOnTarget(target: Vector2):
	var targetPos = target
	_findNearestRootNode(targetPos)
	
	var startPos = _nearestNode.get_end_point();
	targetNode.position = startPos;
	targetNode.look_at(to_global(targetPos));
	
	if _planning_to_draw:
		_draw_ghost_line(startPos, targetPos);
		

func checkCollision(source, target):
	var space_state = get_world_2d().direct_space_state
		
	var query = PhysicsRayQueryParameters2D.create(self.global_position + source, self.global_position + target);
	query.collide_with_areas = true
	query.hit_from_inside = true
	var hit = space_state.intersect_ray(query);
	if hit:
		if hit.collider.has_method("is_blocker"):
			return hit
	return null;

func check_valid_target_node(node:UndergroundCollidable):
	return !node.is_blocker();


func _on_root_section_water_gathered(amount):
	water_gathered.emit(amount);
