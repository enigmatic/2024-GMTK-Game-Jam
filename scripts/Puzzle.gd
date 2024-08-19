extends Node2D

signal reset_puzzle

# Called when the node enters the scene tree for the first time.
func _ready():
	if owner != get_tree().edited_scene_root:
		$Root.queue_free();


func reset():
	reset_puzzle.emit();
