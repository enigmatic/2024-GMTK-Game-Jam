extends Node2D

@onready var root:Root = $Root;
@onready var score_label = $CanvasLayer2/ScoreLabel
@onready var root_label = $CanvasLayer2/RootLabel

var score = 0;
var rootCounter = 5;


func _on_root_growing_root():
	rootCounter -= 1;
	if rootCounter == 0:
		root.canGrow = false;
	root_label.text = 'Roots: ' + str(rootCounter)

func _on_root_water_gathered(amount):
	score += 1;
	score_label.text = "Score: " + str(score);
