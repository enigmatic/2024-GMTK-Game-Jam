extends Node2D

@onready var root:Root = $Root;
@onready var tree_node = $Tree;
@onready var water_node = $Water;
@onready var hud:HUD = $HUD
@onready var start_menu:StartMenu = $HUD/StartMenu
@onready var tutorial:Tutorial = $HUD/Tutorials
@onready var camera:Camera2D = $Camera
@onready var background:Background = $Background

var score = 0;
var root_counter = 2;

func _ready():
	_update_scores();
	start_menu.connect("reset", _reset_game)
	camera.connect("tutorial_step",_on_tutorial_step)
	
func _on_tutorial_step(step:int = 0):
	if step ==1:
		tutorial.set_and_show(tutorial.FIRST_CAMERA_MOVEMENT_TUTORIAL_MESSAGE, tutorial.CAMERA_MOVEMENT_UNLOCK)
	if step==2:
		tutorial.set_and_show(tutorial.FIRST_PUSH_ROCKS_TUTORIAL_MESSAGE,tutorial.PUSH_ROCKS_UNLOCK)
	if step==3:
		tutorial.set_and_show(tutorial.FIRST_RATS_TUTORIAL_MESSAGE,tutorial.RATS_UNLOCK)

# based on https://www.reddit.com/r/godot/comments/cqzifo/reload_a_child_scene/
func _reset_node(old_node:Node)->Node:
	var replacement_scene = load(old_node.scene_file_path);
	var parent = old_node.get_parent();
	var index = old_node.get_index();
	old_node.call_deferred('free');
	var new_node = replacement_scene.instantiate();
	parent.add_child(new_node);
	parent.move_child(new_node, index);
	return new_node;
	

func _reset_game():
	tree_node.reset()
	background.reset()
	root_counter = 2
	score = 0
	water_node = _reset_node(water_node);
	root.reset();
	root.start_growing();
	for puzzle in $Puzzles.get_children():
		puzzle.reset();
	_update_scores();
	var cameraTween = create_tween()
	cameraTween.tween_property(camera, "position", Vector2(320,1), 1).set_ease(Tween.EASE_IN_OUT);
	
func _process(_delta):
	if !$SoundTrackPlayer.playing:
		$SoundTrackPlayer.play()

func _on_root_growing_root():
	root_counter -= 1;
	if root_counter == 0:
		root.stop_growing();
	_update_scores();
	
func _on_root_removed_root():
	if root_counter == 0:
		root.start_growing();
	root_counter += 1;
	_update_scores();

func _on_root_water_gathered(amount):
	root_counter += amount;
	root.start_growing();
	while amount > 0:
		score += 1
		amount -= 1
		if score < 5 or score % 5 == 0:
			tree_node.increase_tree_size(32,true);
	
	_update_scores();
	
func _update_scores():
	hud.set_score(score);
	hud.set_root(root_counter);

func _on_goal_water_collected_from_goal_water():
	start_menu.show_victory_screen();
	background.victory_rain()
	camera.move_camera_to(Vector2(0,-705), 0.25);
