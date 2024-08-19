extends Node2D

@onready var root:Root = $Root;
@onready var tree_node = $Tree
@onready var hud = $HUD
@onready var start_menu = $HUD/StartMenu
@onready var tutorial:Tutorial = $HUD/Tutorials
@onready var camera:Camera2D = $Camera
var score = 0;
var root_counter = 2;
var water_counter = 0;

func _ready():
	_update_scores();
	start_menu.connect("reset", _reset_game)
	camera.connect("tutorial_step",_on_tutorial_step)
	
	
func _on_tutorial_step(step:int = 0):
	if step ==1:
		tutorial.set_and_show(tutorial.FIRST_CAMERA_MOVEMENT_TUTORIAL_MESSAGE, tutorial.CAMERA_MOVEMENT_UNLOCK)
	if step==2:
		tutorial.set_and_show(tutorial.FIRST_PUSH_ROCKS_TUTORIAL_MESSAGE,tutorial.PUSH_ROCKS_UNLOCK)
	
func _reset_game():
	tree_node.reset()
	root_counter = 2
	water_counter = 0
	score = 0
	_update_scores()
	
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
	score += amount;
	root_counter += amount;
	root.start_growing();
	water_counter += amount
	if score < 5 or score % 5 == 0:
		tree_node.increase_tree_size(32,true);
	
	_update_scores();
	
func _update_scores():
	hud.set_score(score);
	hud.set_root(root_counter);
