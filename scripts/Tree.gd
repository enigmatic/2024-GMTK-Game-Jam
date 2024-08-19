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

func reset():
	for f in foliages_node.get_children():
		f.falling = true
	set_tree_size(startingTreeSize)

func increase_tree_size(height: int = 32, tween:bool = false):
	set_tree_size(height+int(size.y), tween)
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


func set_tree_size(height: int= 16, tween:bool = false):
	tree_growing.emit(height);
	var half_h = (height*.5)
	var new_size = Vector2(sqrt(height) * (log(height)-2),height)
	var new_position =  Vector2(320-(sqrt(height) * (log(height)-2)*.5),-height)
	top_foliage.size = Vector2(size.x,size.x)

	var new_foliage_position = Vector2(top_foliage.size.x*.001,-top_foliage.size.x*.5,)
	if tween:
		var tween1 = create_tween()
		var tween2 = create_tween()
		var tween3 = create_tween()
		tween1.tween_property(self,"size",new_size,1.0)
		tween2.tween_property(self,"position",new_position,1.0)
		tween3.tween_property(top_foliage,"position",new_foliage_position,1)
	else:
		size = new_size
		position = new_position
		top_foliage.position = new_foliage_position
		top_foliage.position.y = -top_foliage.size.x*.5
		top_foliage.position.x = top_foliage.size.x*.001
		
	material.set_shader_parameter("pixelization", half_h)
	material.set_shader_parameter("width", size.x)
	top_foliage.material.set_shader_parameter("pixelization", size.x*.5)
	top_foliage.material.set_shader_parameter("radius", size.x*.5*.7)

func add_foliage(foliage_position:Vector2 = Vector2(-1,-1), radius: int = -1):
	var new_foliage = foliage_preload.instantiate()
	foliages_node.add_child(new_foliage)
	
	if radius == -1:
		radius = randi_range(4,clamp(size.y*.2,5,16))
	if foliage_position == Vector2(-1,-1):
		foliage_position = Vector2(0, randi_range(size.y*.1,size.y*.2))
		foliage_position.y = position.y
		if last_foliage_side < 0.0:
			foliage_position.x = randi_range(310,320)
			new_foliage.grow_direction = -4.5
		else:
			foliage_position.x = randi_range(320,330)-radius
			new_foliage.grow_direction = -1
		
		last_foliage_side *= -1
		#print(str(foliage_position) + "  "+  str(position.x) + "  "+  str(size.x))
	
	new_foliage.size = Vector2(0,0)
	new_foliage.anchors_preset = PRESET_CENTER
	new_foliage.layout_mode = 1
	var tween = create_tween()
	var tween2 = create_tween()
	new_foliage.position = foliage_position
	tween.tween_property(new_foliage, "size", Vector2(radius*2,radius*2),1)
	tween2.tween_property(new_foliage, "position", Vector2(foliage_position.x,foliage_position.y-radius*2),1.0)

	
	new_foliage.material.set_shader_parameter("pixelization", radius*1.3)
	new_foliage.material.set_shader_parameter("radius", radius)
	new_foliage.material.get_shader_parameter("green_noise").noise.seed = randi()
	new_foliage.material.get_shader_parameter("shape_noise").noise.seed = randi()

