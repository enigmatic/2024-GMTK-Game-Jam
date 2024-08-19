extends Node2D
class_name Tutorial

@onready var label: Label = $Panel/Label

var active_message:int = 0
var unlocked_messages:int = 4

const FIRST_CAMERA_MOVEMENT_TUTORIAL_MESSAGE = 5
const CAMERA_MOVEMENT_UNLOCK = 7

const FIRST_PUSH_ROCKS_TUTORIAL_MESSAGE = 9
const PUSH_ROCKS_UNLOCK = 11

var settings:Settings


const TUTORIAL_MESSAGES:Array[String] = [
	"Click to grow a root",
	"Hold to see where the root will grow, right click to cancel",
	"Grow roots to water to help your tree grow",
	"Grow your roots as deep as you can!",
	"Press T to bring the tutorial and tips back up",
	
	"Zoom in and out by scrolling",
	"As the tree grows, you can zoom out further",
	"Move the camera with WASD, Arrow keys",
	"Drag the camera with Middle or Right Click",
	
	"Some rocks can be pushed with roots",
	"Press R to undo",
	"Don't forget to see how large your tree has grown!",

	]
# Called when the node enters the scene tree for the first time.
func _ready():
	if ResourceLoader.exists("user://settings.tres"):
		settings = ResourceLoader.load("user://settings.tres")
		if settings.tutorial_step >0:
			active_message = settings.tutorial_step
			label.text = TUTORIAL_MESSAGES[active_message]
			$BackButton.show()
		if settings.unlocked_tutorials > unlocked_messages:
			unlocked_messages = settings.unlocked_tutorials
		if settings.tutorial_showing == false:
			hide()
	else:
		settings = Settings.new()


func set_and_show(message_index:int, unlocked_message:int = -1):
	if unlocked_message > unlocked_messages:
		unlocked_messages = unlocked_message
		active_message = message_index
		label.text = TUTORIAL_MESSAGES[active_message]
		$BackButton.show()
		show()
		_save_tutorial()
	

func _on_back_button_button_up():
	if active_message >0:
		active_message-=1
	if active_message ==0:
		$BackButton.hide()
	label.text = TUTORIAL_MESSAGES[active_message]
	if $NextButton.text == "Close":
		$NextButton.text = "Next"
	_save_tutorial()


func _on_next_button_button_up():
	$BackButton.show()
	if $NextButton.text == "Close":
		hide()
		active_message = -1
		$BackButton.hide()
		$NextButton.text = "Next"
	if active_message < unlocked_messages:
		active_message+=1
	if active_message == unlocked_messages:
		$NextButton.text = "Close"
	label.text = TUTORIAL_MESSAGES[active_message]
	_save_tutorial()
	

func _input(event):
	if event.is_action_released("tutorial"):
		if visible:
			hide()
		else:
			show()

func _save_tutorial():
	var old_settings 
	if ResourceLoader.exists("user://settings.tres"):
		old_settings = ResourceLoader.load("user://settings.tres")
	if old_settings:
		settings.music_level = old_settings.music_level
		settings.sound_level = old_settings.sound_level
	settings.tutorial_showing = visible
	settings.tutorial_step = active_message
	settings.unlocked_tutorials = unlocked_messages
	ResourceSaver.save(settings,"user://settings.tres")
