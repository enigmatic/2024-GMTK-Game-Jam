extends Node2D

@onready var root:Root = $Root;
@onready var score_label = $CanvasLayer2/ScoreLabel
@onready var root_label = $CanvasLayer2/RootLabel
@onready var tree_node = $Tree

var score = 0;
var rootCounter = 2;
var water_counter = 0;

func _ready():
	_updateScores();

func _on_root_growing_root():
	rootCounter -= 1;
	if rootCounter == 0:
		root.stop_growing();
	_updateScores();

func _on_root_water_gathered(amount):
	score += amount;
	rootCounter += amount;
	root.start_growing();
	water_counter += amount
	if score < 5 or score % 5 == 0:
		tree_node.increase_tree_size()
	
	_updateScores();
	
func _updateScores():
	score_label.text = "Score: " + str(score);
	root_label.text = 'Roots: ' + str(rootCounter);
