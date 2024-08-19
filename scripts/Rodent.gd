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

@onready var mover:CharacterBody2D = $CharacterBody2D
@onready var burrow:Line2D = $Burrow
@onready var sprite = $CharacterBody2D/Rat

var _target;
# Called when the node enters the scene tree for the first time.
func _ready():
	mover.position = start_pos.position;
	_target = end_pos.position;
	sprite.flip_h = false;
	burrow.clear_points();
	burrow.add_point(start_pos.position-  Vector2(sprite.texture.get_width()/2,0));
	burrow.add_point(end_pos.position + Vector2(sprite.texture.get_width()/2, 0));
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mover.position = mover.position.move_toward(_target, delta * speed);
	if mover.position == _target:
		if _target == end_pos.position:
			_target = start_pos.position;
			sprite.flip_h = true;
		else:
			_target = end_pos.position;
			sprite.flip_h = false;
