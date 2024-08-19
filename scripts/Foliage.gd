extends TextureRect

var grow_direction:int = -1
var falling:bool = false
var done_falling:bool = false
var gravity:float = 2.0
var terminal_velocity:int = 50
var velocity: Vector2 = Vector2(0,0)
var clean_up_timer:float = 2.0
@onready var fall_sound = $FallSound
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if falling:
		if position.y < -size.y:
			velocity.y += gravity * delta * randf_range(.8,1.2)
			if position.y + velocity.y + 1> -size.y:
				position.y = 0-size.y*.9
				velocity.y=0
				done_falling = true
				fall_sound.pitch_scale = randf_range(.4,1)
				fall_sound.play()
		position += velocity
	if done_falling:
		clean_up_timer -=delta
		size.y *= .98 * (1-delta)
		position.y = 0-size.y
		if clean_up_timer <0:
			queue_free()
	
