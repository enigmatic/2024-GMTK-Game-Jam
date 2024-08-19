extends Node2D
class_name Root

signal growing_root;
signal removed_root;
signal water_gathered(amount:int);

@export var groundLevel: int = 0;
@export var rootSectionMaxSize = 100;
@export var rootSectionMinSize = 25;

@onready var rootList = $RootList;
@onready var targetNode = $Target;
@onready var ghostLine = $GhostLine;
@onready var _nearestNode: RootSection = $RootList/RootSection;

var _grow_to_position = Vector2(0,0);

var _can_grow = false;
var _cancelClick = false;
var _planning_to_draw = false;
var _removable_roots = [];

func _process(delta):
	if _planning_to_draw:
		_calculate_path();

func _unhandled_input(event):
	if event is InputEventMouse:
		if _can_grow:
			_calculate_path();
			
			if event is InputEventMouseButton:
				if event.button_index == 1:
					if event.is_released():
						if _cancelClick:
							return;
						var okToGrow = true;
						var collideWith = null;
						var start_point = _nearestNode.get_end_point();
						var hitInfo = checkCollision(start_point, _grow_to_position);
						if hitInfo:
							collideWith = hitInfo.collider;
							okToGrow = check_valid_target_node(collideWith);
							if (collideWith.type == 'water'):
								_grow_to_position = to_local(hitInfo.position);
						elif (start_point.distance_to(_grow_to_position) < rootSectionMinSize):
							okToGrow = false;

						if okToGrow:
							_growRoot(_grow_to_position, hitInfo);
						_planning_to_draw = false;
					else:
						_cancelClick = false;
						_planning_to_draw = true;
				else:
					cancel_growing();
	elif event.is_action_released('undo'):
		if (_removable_roots.size() > 0):
			_removable_roots.pop_front().remove();
			removed_root.emit();
		
func _growRoot(target: Vector2, collideInfo):
	var scene = load("res://scenes/RootSection.tscn");
	var section:RootSection = scene.instantiate();
	section.parent = _nearestNode;
	section.target = target;
	section.collision = collideInfo;
	if collideInfo:
		section.touching = collideInfo.collider;
	section.done_growing.connect(_calculate_path)
	section.water_flowing.connect(_on_root_section_water_flowing);
	rootList.add_child(section);
	_removable_roots.push_front(section);
	growing_root.emit();

func _calculate_path():
	_grow_to_position = null;
	var target = get_target_position();
	_nearestNode = _find_best_node(target);
	
	var startPos = _nearestNode.get_end_point();
	targetNode.position = startPos;
	targetNode.look_at(to_global(target));
	
	if _planning_to_draw:
		_grow_to_position = startPos.move_toward(target, rootSectionMaxSize);
	
		ghostLine.visible = true;
		_draw_ghost_line(_nearestNode.get_end_point(), _grow_to_position);
	else:
		ghostLine.visible = false;
	

func _find_best_node(pos: Vector2) -> RootSection:
	var roots = rootList.get_children();
	var nearest: RootSection = roots[0]
	var nearDist = nearest.get_end_point().distance_to(pos);
	var clearPath = false;
	for root in roots:
		var testPos = root.get_end_point();
		if testPos == null:
			continue;
		var dist = testPos.distance_to(pos);
		if (dist < nearDist) && (dist > rootSectionMinSize):
			var hit = checkCollision(pos, testPos);
			if hit && hit.collider.blocker:
				if !clearPath:
					nearest = root;
					nearDist = dist;
			else:
				clearPath = true;
				nearest = root;
				nearDist = dist;
		elif !clearPath:
			if !checkCollision(pos, testPos):
				clearPath = true;
				nearest = root;
				nearDist = dist;

	return nearest;
	
func _draw_ghost_line(start: Vector2, target: Vector2):
	# line location
	ghostLine.set_point_position(0, start);
	ghostLine.set_point_position(1, target);
	
	# will it run into anything?
	var hitInfo = checkCollision(start, target);
	
	if hitInfo:
		var collidedWith = hitInfo.collider;
		var collideType = collidedWith.type;
		if collidedWith.blocker:
			ghostLine.default_color = Color(1,0,0);
		elif (['water', 'pushable'].has(collideType)):
			ghostLine.default_color = Color(0,0,1);
			if (collideType == 'water'):
				ghostLine.set_point_position(1, to_local(hitInfo.position));
		else:
			ghostLine.default_color = Color(1,0,0);
	elif (start.distance_to(target) < rootSectionMinSize):
		ghostLine.default_color = Color(1,1,1);
	else:
		ghostLine.default_color = Color(0,1,0);

func checkCollision(source, target):
	var space_state = get_world_2d().direct_space_state
		
	var query = PhysicsRayQueryParameters2D.create(self.global_position + source, self.global_position + target);
	query.collide_with_areas = true
	query.hit_from_inside = true
	var hit = space_state.intersect_ray(query);
	if hit:
		if hit.collider is UndergroundCollidable:
			return hit
	return null;

func check_valid_target_node(node:UndergroundCollidable):
	return !node.blocker;

func get_target_position() -> Vector2:
	var targetClamp = get_local_mouse_position();
	targetClamp.y = max(groundLevel, targetClamp.y);
	return targetClamp;

func _on_root_section_water_gathered(amount):
	water_gathered.emit(amount);

func _on_root_section_water_flowing(section:RootSection):
	if section.water_flowing.is_connected(_on_root_section_water_flowing):
		section.water_flowing.disconnect(_on_root_section_water_flowing);
	_removable_roots.erase(section);
	

func stop_growing():
	_can_grow = false;
	_planning_to_draw = false;
	ghostLine.visible = false;
	
func start_growing():
	
	if !_can_grow && Input.is_mouse_button_pressed( 1 ):
		_planning_to_draw = true;
		_calculate_path()
	_can_grow = true;

func cancel_growing():
	_cancelClick = true;
	ghostLine.visible = false;
	_planning_to_draw = false;

func _on_root_section_done_growing():
	start_growing();
