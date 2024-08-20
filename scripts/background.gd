extends Node2D
class_name Background

var raining: bool = false

func victory_rain():
	raining = true
	_on_rain_timer_timeout()
	
func reset():
	raining = false
	$RainParticles.emitting = false
	$RainTimer.stop()
	

func _on_rain_timer_timeout():
	if raining:
		$RainParticles.emitting = !$RainParticles.emitting
		if $RainParticles.emitting:
			$RainTimer.start(5)
		else:
			$RainTimer.start(10)
