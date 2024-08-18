extends UndergroundVolume
class_name PushableRock

var _can_move = true;
var _positionQueue = [];

func _ready():
	_positionQueue.push_front(position);
	super._ready();

func is_blocker():
	return !_can_move;

func type():
	return 'pushable';

func push(startPos, targetPos)->bool:
	var moveVec = targetPos - startPos;
	self.position += moveVec;
	return _can_move;
	
func start_push():
	if (_can_move):
		_positionQueue.push_front(position);

func _on_body_entered(body):
	_can_move = false;

func reset():
	position = _positionQueue.pop_front();
	_can_move = true;
	
