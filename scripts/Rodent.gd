@tool
extends Node2D

@export var start_pos:Marker2D:
	set(new_pos):
		start_pos = new_pos;
		
@export var end_pos:Marker2D:
	set(new_pos):
		end_pos = new_pos;
		
@export var speed = 100:
	set(new_speed):
		speed = new_speed;

@onready var mover:Area2D = $Area2D
@onready var burrow:Line2D = $Burrow
@onready var chewing = $Area2D/Rat/sprite/GPUParticles2D

var _target;
var _moving = true;
# Called when the node enters the scene tree for the first time.
func _ready():
	mover.position = start_pos.position;
	_target = end_pos.position;
	mover.scale.x = 1;
	burrow.clear_points();
	burrow.add_point(start_pos.position - Vector2(96/2,0));
	burrow.add_point(end_pos.position + Vector2(96/2, 0));
	pass # Replace with func$Area2D/Rat


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _moving:
		mover.position = mover.position.move_toward(_target, delta * speed);
		if mover.position == _target:
			turn_around()

func turn_around():
	if _target == end_pos.position:
		_target = start_pos.position;
		mover.scale.x = -1;
	else:
		_target = end_pos.position;
		mover.scale.x = 1;
	

func _on_area_2d_area_entered(area:Area2D):
	if area.get_parent() is RootSection:
		chewing.emitting = true;	
		var root = area.get_parent().remove();
	else:
		turn_around();


func _on_gpu_particles_2d_finished():
	_moving = true;


func _on_area_2d_body_entered(body):
	turn_around();
