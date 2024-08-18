extends Node2D

@onready var root:Root = $Root;
@onready var tree_node = $Tree
@onready var hud = $HUD

var score = 0;
var rootCounter = 2;
var water_counter = 0;

func _ready():
	_updateScores();
	
func _process(_delta):
	if !$SoundTrackPlayer.playing:
		$SoundTrackPlayer.play()

func _on_root_growing_root():
	rootCounter -= 1;
	if rootCounter == 0:
		root.stop_growing();
	_updateScores();
	
func _on_root_removed_root():
	if rootCounter == 0:
		root.start_growing();
	rootCounter += 1;
	_updateScores();

func _on_root_water_gathered(amount):
	score += amount;
	rootCounter += amount;
	root.start_growing();
	water_counter += amount
	if score < 5 or score % 5 == 0:
		tree_node.increase_tree_size(32);
	
	_updateScores();
	
func _updateScores():
	hud.set_score(score);
	hud.set_root(rootCounter);
