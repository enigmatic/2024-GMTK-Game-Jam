@tool
extends Water
class_name GoalWater

signal collected_from_goal_water;

var _emited_win_condition = false;

func consume(units:int, consuming_location:Vector2) -> int:
	if(!_emited_win_condition):
		collected_from_goal_water.emit();
		_emited_win_condition = true;
	
	
	return super.consume(units, consuming_location);
