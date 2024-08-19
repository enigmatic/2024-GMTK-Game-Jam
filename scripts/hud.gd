extends CanvasLayer
class_name HUD
@onready var score_label: Label = $ScoreLabel
@onready var root_label: Label = $RootLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_score(score:int = 0):
	score_label.text = "Score: " + str(score);
	
func set_root(root_counter:int = 0):
	root_label.text = 'Roots: ' + str(root_counter);
