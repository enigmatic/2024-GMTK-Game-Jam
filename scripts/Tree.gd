extends TextureRect

signal tree_growing(int);

@export_range(16,1024,16) var startingTreeSize = 16

@onready var top_foliage = $TopFoliage
@onready var foliages_node = $Foliages
var foliage_preload = preload("res://scenes/foliage.tscn")
var last_foliage_side = -1
# Called when the node enters the scene tree for the first time.

func _ready():
	#set_tree_size(128)
	reset();
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	pass

func reset():
	for f in foliages_node.get_children():
		f.queue_free()
	set_tree_size(startingTreeSize)

func increase_tree_size(height: int = 32):
	set_tree_size(height+size.y)
	var height_h = height * .4
	for foliage in foliages_node.get_children():
		foliage.size.x += height_h*.6
		foliage.size.y += height_h*.6
		foliage.position.y -= height_h*.5
		foliage.position.x += foliage.grow_direction * height_h*.1
		foliage.material.set_shader_parameter("pixelization", foliage.size.y*.5*1.3)
		foliage.material.set_shader_parameter("radius", foliage.size.y * .5)
	for i in range(0,height,32):
		add_foliage()


func set_tree_size(height: int= 16):
	tree_growing.emit(height);
	var half_h = (height*.5)
	var quarter_h = height*.25
	size.y = height
	size.x = sqrt(height) * (log(height)-3)
	material.set_shader_parameter("pixelization", half_h)
	material.set_shader_parameter("width", size.x)
	position.x = 320-(size.x*.5)
	#position.y = 15
	position.y = -size.y
	top_foliage.size = Vector2(size.x,size.x)
	top_foliage.position.y = -top_foliage.size.x*.5
	top_foliage.position.x = top_foliage.size.x*.001
	top_foliage.material.set_shader_parameter("pixelization", size.x*.5)
	top_foliage.material.set_shader_parameter("radius", size.x*.5*.7)

func add_foliage(foliage_position:Vector2 = Vector2(-1,-1), radius: int = -1):
	var new_foliage = foliage_preload.instantiate()
	if radius == -1:
		radius = randi_range(4,clamp(size.y*.2,5,16))
	if foliage_position == Vector2(-1,-1):
		foliage_position = Vector2(0, randi_range(size.y*.1,size.y*.2))
		foliage_position.y = position.y
		if last_foliage_side < 0:
			foliage_position.x = randi_range(310,320)
			new_foliage.grow_direction = -4.5
		else:
			foliage_position.x = randi_range(320,330)-radius
			new_foliage.grow_direction = -1
		
		last_foliage_side *= -1
		#print(str(foliage_position) + "  "+  str(position.x) + "  "+  str(size.x))


	new_foliage.size.x = radius*2
	new_foliage.size.y = radius*2
	foliages_node.add_child(new_foliage)
	new_foliage.position = foliage_position
	new_foliage.material.set_shader_parameter("pixelization", radius*1.3)
	new_foliage.material.set_shader_parameter("radius", radius)
	new_foliage.material.get_shader_parameter("green_noise").noise.seed = randi()
	new_foliage.material.get_shader_parameter("shape_noise").noise.seed = randi()

