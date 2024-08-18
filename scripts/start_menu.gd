extends Panel


signal reset
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_released("ui_cancel"):
		if visible:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true



func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Soundtrack"),linear_to_db(value/100.0))


func _on_play_button_button_up():
	hide()
	get_tree().paused = false

func _on_reset_button_button_up():
	reset.emit()
