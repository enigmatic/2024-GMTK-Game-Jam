extends Node2D

signal goal_water_found;

func _on_goal_water_collected_from_goal_water():
	goal_water_found.emit();
