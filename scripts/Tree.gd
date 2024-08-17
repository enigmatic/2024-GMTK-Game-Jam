extends TextureRect

@onready var top_foliage = $TopFoliage
var foliage_preload = preload("res://scenes/foliage.tscn")
# Called when the node enters the scene tree for the first time.

func _ready():
	set_tree_size(500)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_tree_size(height: int= 16):
	var half_h = (height*.5)
	var quarter_h = height*.25
	size.y = height
	size.x = sqrt(height) * (log(height)-3)
	material.set_shader_parameter("pixelization", half_h)
	material.set_shader_parameter("width", size.x)
	position.x = 320-(size.x*.5)
	#position.y = 15
	position.y = -size.y
	top_foliage.size = Vector2(half_h,half_h)
	top_foliage.position.y = -top_foliage.size.x*.5
	top_foliage.position.x = -top_foliage.size.x*.33
	top_foliage.material.set_shader_parameter("pixelization", quarter_h)
	top_foliage.material.set_shader_parameter("radius", quarter_h*.7)

func add_foliage(position:Vector2, radius: int):
	pass
