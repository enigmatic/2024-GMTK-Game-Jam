@tool
extends UndergroundVolume
class_name PushableRock

var _positionQueue = [];

func _ready():
	
	_positionQueue.push_front(position);
	super._ready();

func push(startPos, targetPos)->bool:
	var moveVec = targetPos - startPos;
	self.position += moveVec;
	return !blocker;
	
func start_push():
	if (!blocker):
		_positionQueue.push_front(position);

func _on_body_entered(_body):
	blocker = true;
	
func reset(_amount):
	position = _positionQueue.pop_front();
	blocker = false;
	
