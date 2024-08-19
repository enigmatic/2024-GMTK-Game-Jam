@tool
extends Node2D

@export var start_pos:Marker2D:
	set(new_pos):
		start_pos = new_pos;
		_update_burrow();
		
@export var end_pos:Marker2D:
	set(new_pos):
		end_pos = new_pos;
		_update_burrow();
		
@export var speed = 100:
	set(new_speed):
		speed = new_speed;

@onready var mover:Area2D = $Area2D
@onready var burrow:Line2D = $Burrow
@onready var chewing = $Area2D/Rat/sprite/GPUParticles2D

var _target;
var _moving = true;
var _goal_found = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	mover.position = start_pos.position;
	_target = end_pos.position;
	mover.scale.x = 1;
	_update_burrow();
	pass # Replace with func$Area2D/Rat


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _moving:
		mover.position = mover.position.move_toward(_target, delta * speed);
		if mover.position == _target:
			turn_around()

func _update_burrow():
	if (burrow):
		burrow.clear_points();
		burrow.add_point(start_pos.position - Vector2(96/2,0));
		burrow.add_point(end_pos.position + Vector2(96/2, 0));
		

func turn_around():
	if _target == end_pos.position:
		_target = start_pos.position;
		mover.scale.x = -1;
	else:
		_target = end_pos.position;
		mover.scale.x = 1;
	

func _on_area_2d_area_entered(area:Area2D):
	if area.get_parent() is RootSection:
		if (!_goal_found):
			chewing.emitting = true;	
			var root = area.get_parent().remove();
	elif area.type != 'rodent':
		turn_around();


func _on_gpu_particles_2d_finished():
	_moving = true;


func _on_area_2d_body_entered(body):
	turn_around();

func _on_water_collected_from_goal_water():
	_goal_found = true;
	
func reset():
	_goal_found = false;

func _on_puzzle_reset():
	reset();
