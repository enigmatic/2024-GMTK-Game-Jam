extends Panel
class_name StartMenu

signal reset
var settings:Settings
@onready var music_slider: Slider = $VBoxContainer/AudioSettings/MusicSlider
@onready var sound_slider: Slider = $VBoxContainer/AudioSettings/SoundSlider
@onready var victory_label:Label = $VBoxContainer/VictoryLabel
# Called when the node enters the scene tree for the first time.

func _ready():
	load_settings()


func _input(event):
	if event.is_action_released("ui_cancel"):
		if visible:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true

func show_victory_screen():
	show()
	victory_label.show()
	$VBoxContainer/AudioSettings.hide()

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Soundtrack"),linear_to_db(value/100.0))
	settings.music_level = value
	var old_settings 
	if ResourceLoader.exists("user://settings.tres"):
		old_settings = ResourceLoader.load("user://settings.tres")
	if old_settings:
		settings.tutorial_showing = old_settings.tutorial_showing
		settings.tutorial_step = old_settings.tutorial_step
		settings.unlocked_tutorials = old_settings.unlocked_tutorials
	ResourceSaver.save(settings,"user://settings.tres")

func _on_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear_to_db(value/100.0))
	settings.sound_level = value
	var old_settings 
	if ResourceLoader.exists("user://settings.tres"):
		old_settings = ResourceLoader.load("user://settings.tres")
	if old_settings:
		settings.tutorial_showing = old_settings.tutorial_showing
		settings.tutorial_step = old_settings.tutorial_step
		settings.unlocked_tutorials = old_settings.unlocked_tutorials
	ResourceSaver.save(settings,"user://settings.tres")


func _on_play_button_button_up():
	hide()
	get_tree().paused = false

func _on_reset_button_button_up():
	reset.emit()
	victory_label.hide()
	$VBoxContainer/AudioSettings.show()
	

func load_settings():
	if ResourceLoader.exists("user://settings.tres"):
		settings = ResourceLoader.load("user://settings.tres")
		if settings.music_level>-1:
			music_slider.value = settings.music_level
			sound_slider.value = settings.sound_level
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Soundtrack"),linear_to_db(settings.music_level/100.0))
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear_to_db(settings.sound_level/100.0))
	else:
		settings = Settings.new()



func _on_tutorial_button_button_up():
	get_parent().find_child("Tutorials").show()
